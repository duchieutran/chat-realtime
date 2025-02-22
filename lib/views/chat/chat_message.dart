import 'package:chatting/models/message_model.dart';
import 'package:chatting/models/users_model.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/friend_viewmodel.dart';
import 'package:chatting/view_models/message_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  final String chatId;
  final String receiverUid;
  final String receiverName;
  final String receiverAvatar;
  final bool isAdmin;

  const MessageScreen({
    super.key,
    required this.chatId,
    required this.receiverUid,
    required this.receiverName,
    required this.receiverAvatar,
    this.isAdmin = false,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController messageController = TextEditingController();
  final FriendViewModel friendsVM = FriendViewModel();
  final MessageViewModel messageViewModel = MessageViewModel();
  List<Users> friends = [];
  List<Users> memberInGroup = [];

  void getFriends() async {
    try {
      List<Users>? user = await friendsVM.getFriend();
      if (user != null) {
        setState(() {
          friends = user;
        });
      } else {
        friends = [];
      }
    } catch (e) {
      rethrow;
    }
  }

  // get user trong nhom
  Future<void> getMemberInGroup() async {
    try {
      List<Users>? user =
          await messageViewModel.getUser(uidGroup: widget.chatId);
      setState(() {
        memberInGroup = user;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFriends();
      getMemberInGroup();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageViewModel = Provider.of<MessageViewModel>(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildAppBarMessage(size, context),
          Expanded(child: _buildMessageList(messageViewModel)),
          _buildMessageInput(messageViewModel, friends),
        ],
      ),
    );
  }

  Widget _buildAppBarMessage(Size size, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 16, right: 16, bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      width: size.width,
      height: size.height * 0.08,
      decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.grey40,
              spreadRadius: 5,
              blurRadius: 15,
              offset: Offset(0, 0), // Bóng đều ở cả 4 cạnh
            ),
          ]),
      child: Row(
        children: [
          // back
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.dark,
            ),
          ),
          // avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.08,
                height: size.width * 0.08,
                decoration: BoxDecoration(
                    color: AppColors.blue20,
                    border: Border.all(color: AppColors.dark, width: 1),
                    borderRadius: BorderRadius.circular(size.width * 0.1)),
                child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.receiverAvatar)),
              ),
              const SizedBox(width: 10),
              Text(
                widget.receiverName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMessageList(MessageViewModel messageViewModel) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blue20, width: 4),
        boxShadow: const [
          BoxShadow(
            color: AppColors.grey40,
            spreadRadius: 7,
            blurRadius: 15,
            offset: Offset(0, 0), // Bóng đều ở cả 4 cạnh
          ),
        ],
      ),
      child: StreamBuilder<List<MessageModel>>(
        stream: messageViewModel.getMessageStream(widget.chatId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Image(image: AssetImage(gifLoading)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No messages yet."));
          }
          var messages = snapshot.data!;
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(messages[index], messageViewModel);
            },
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(
      MessageModel message, MessageViewModel messageViewModel) {
    bool isMe = message.senderId == messageViewModel.auth.currentUser!.uid;
    String urlAvatar = message.senderAvatar;
    String name = message.senderName;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  _formatTimestamp(message.timestamp.toDate()),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Nội dung của tin nhắn
          Column(
            children: [
              // Tên người nhắn tin (chỉ hiển thị với người bên kia)
              Row(children: [
                const SizedBox(width: 40),
                isMe
                    ? const SizedBox()
                    : Text(name,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey40))
              ]),
              // ảnh đại diện + tin nhắn
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  isMe
                      ? const SizedBox()
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                              color: AppColors.blue40,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(urlAvatar),
                          ),
                        ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.text,
                      style:
                          TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // widget gui tin nhan
  Widget _buildMessageInput(
      MessageViewModel messageViewModel, List<Users> users) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                hintText: "Enter a message...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (messageController.text.isNotEmpty) {
                messageViewModel.sendMessage(
                  chatId: widget.chatId,
                  text: messageController.text,
                  senderId: messageViewModel.auth.currentUser!.uid,
                );
                messageController.clear();
              }
            },
            child: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 24,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ham format
  String _formatTimestamp(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute}, ${dateTime.day} ${dateTime.month} ${dateTime.year}";
  }
}

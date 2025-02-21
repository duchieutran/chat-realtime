import 'package:chatting/models/message_model.dart';
import 'package:chatting/models/users_model.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/friend_viewmodel.dart';
import 'package:chatting/view_models/message_vm.dart';
import 'package:chatting/views/chat/update_group.dart';
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

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(messageViewModel)),
          _buildMessageInput(messageViewModel, friends),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(widget.receiverAvatar)),
          const SizedBox(width: 10),
          Text(
            widget.receiverName,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: widget.isAdmin
          ? [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateGroup(
                        users: friends,
                        isUpdate: true,
                        groupName: widget.receiverName,
                        uidGroup: widget.chatId,
                        usersInGroup: memberInGroup,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.group_add),
              )
            ]
          : [],
    );
  }

  Widget _buildMessageList(MessageViewModel messageViewModel) {
    return StreamBuilder<List<MessageModel>>(
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

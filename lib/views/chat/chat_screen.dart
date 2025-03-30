import 'package:chatting/models/chat_room_model.dart';
import 'package:chatting/models/users_model.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/friend_viewmodel.dart';
import 'package:chatting/view_models/message_vm.dart';
import 'package:chatting/views/chat/chatgenimi.dart';
import 'package:chatting/views/chat/update_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final auth = FirebaseAuth.instance;
  FriendViewModel friends = FriendViewModel();
  List<Users> users = [];
  TextEditingController searchController = TextEditingController();
  List<ChatRoomModel> filteredRooms = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFriends();
      Provider.of<MessageViewModel>(context, listen: false).getChatRoom();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void getFriends() async {
    try {
      List<Users>? user = await friends.getFriend();
      if (user != null) {
        setState(() {
          users = user;
        });
      } else {
        users = [];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<MessageViewModel>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatGenimi(),
              ));
        },
        backgroundColor: Color(0xff74a99b),
        child: Image.asset(logoChatGPT),
      ),
      body: Column(
        children: [
          // app bar
          _buildAppBar(size, context),
          // list chat room
          _buildListChat(size, chatViewModel),
        ],
      ),
    );
  }

  Widget _buildListChat(Size size, MessageViewModel chatViewModel) {
    return Expanded(
      child: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: StreamBuilder<List<ChatRoomModel>>(
          stream: chatViewModel.listRoom,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Image(image: AssetImage(gifLoading)));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No messages yet"));
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong!"));
            }

            List<ChatRoomModel> rooms = snapshot.data!;

            return ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: rooms.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                DateTime dateTime = rooms[index].lastMessage!.lastSend.toDate();
                String time = DateFormat('HH:mm').format(dateTime);
                if (rooms[index].type == 'private') {
                  List<String> members = rooms[index].members;
                  String uidCurrent = auth.currentUser!.uid;
                  String name =
                      uidCurrent == members[0] ? members[1] : members[0];

                  return FutureBuilder<Users?>(
                    future: friends.findFriendsUID(uid: name),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Users user = snapshot.data!;
                        return ChatTile(
                          uid: rooms[index].chatId,
                          urlAvatar: user.urlAvatar,
                          userName: user.name,
                          messageLast: rooms[index].lastMessage?.content ?? "",
                          timeLast: time,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                }
                return ChatTile(
                  uid: rooms[index].chatId,
                  urlAvatar: rooms[index].urlAvatar,
                  userName: rooms[index].name,
                  messageLast:
                      rooms[index].lastMessage?.content ?? "Say hi! 👋",
                  timeLast: time,
                  isAdmin: rooms[index].uidAdmin == auth.currentUser!.uid,
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Widget _buildNotifications(Size size) {
  //   return Container(
  //     width: size.width,
  //     height: 30,
  //     decoration: BoxDecoration(
  //       color: AppColors.violet10,
  //     ),
  //     child: Center(
  //       child: Text(
  //         "Chuc ban ngay moi tot lanh",
  //         style: TextStyle(
  //           color: AppColors.dark,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAppBar(Size size, BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateGroup(users: users)),
                  );
                },
                child: const Icon(
                  Icons.group_add,
                ),
              ),
              const SizedBox(width: 15),
            ],
          )
        ],
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.userName,
    required this.urlAvatar,
    required this.uid,
    required this.messageLast,
    required this.timeLast,
    this.isAdmin = false,
  });

  final String userName;
  final String urlAvatar;
  final String uid;
  final String messageLast;
  final String timeLast;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              chatId: uid,
              receiverAvatar: urlAvatar,
              receiverUid: uid,
              receiverName: userName,
              isAdmin: isAdmin,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueAccent,
              backgroundImage:
                  urlAvatar.isNotEmpty ? NetworkImage(urlAvatar) : null,
              foregroundColor: Colors.white,
              child: urlAvatar.isEmpty
                  ? const Icon(Icons.person, color: Colors.white, size: 30)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    messageLast,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Text(
              timeLast,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

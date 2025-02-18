import 'package:chatting/models/chat_room_model.dart';
import 'package:chatting/models/users_model.dart';
import 'package:chatting/view_models/friend_viewmodel.dart';
import 'package:chatting/view_models/message_vm.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFriends();
      Provider.of<MessageViewModel>(context, listen: false).getChatRoom();
    });
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

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Messages",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateGroup(users: users)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<ChatRoomModel>>(
          stream: chatViewModel.listRoom,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No messages yet"));
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong!"));
            }

            List<ChatRoomModel> rooms = snapshot.data!;

            return ListView.separated(
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
                          messageLast:
                              rooms[index].lastMessage?.content ?? "Say hi! 👋",
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
                  isGroup: true,
                );
              },
            );
          },
        ),
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
    this.isGroup = false,
  });

  final String userName;
  final String urlAvatar;
  final String uid;
  final String messageLast;
  final String timeLast;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              chatId: uid,
              receiverAvatar: urlAvatar,
              receiverUid: uid,
              receiverName: userName,
              isGroup: isGroup,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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

import 'package:chatting/models/users.dart';
import 'package:chatting/view_models/friends_vm/friend_viewmodel.dart';
import 'package:chatting/views/chat/chat_message.dart';
import 'package:chatting/views/chat/create_group_screen.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Khai báo
  FriendViewModel friends = FriendViewModel();
  List<Users> users = [];

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  // hàm lấy thông tin bạn bè
  getFriends() async {
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Messages", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGroupScreen(users: users)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: users.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return ChatTile(
              uid: users[index].uid,
              urlAvatar: users[index].urlAvatar,
              userName: users[index].name,
            );
          },
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.userName, required this.urlAvatar, required this.uid});
  final String userName;
  final String urlAvatar;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageScreen(
                receiverName: userName,
                receiverAvatar: urlAvatar,
                receiverUid: uid,
              ),
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueAccent,
              backgroundImage: NetworkImage(urlAvatar),
              child: urlAvatar.isNotEmpty ? null : const Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Last message preview...",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Text("chat now ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text("3", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

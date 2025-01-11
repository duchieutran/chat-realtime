import 'package:chatting/data_sources/app_colors.dart';
import 'package:chatting/data_sources/app_routers.dart';
import 'package:chatting/view_models/auths/auth_service.dart';
import 'package:chatting/view_models/chat/chat_service.dart';
import 'package:chatting/views/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../widgets/user_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
              color: AppColors.light,
              fontWeight: FontWeight.w500,
              fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: AppColors.grey40,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouters.initUpdate);
              },
              icon: const Icon(Icons.next_plan))
        ],
      ),
      drawer: const DrawerHome(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userdata) => _buildUserListItem(userdata, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          // tapper on a user -> go to chat page
          Navigator.pushNamed(context, AppRouters.chat, arguments: {
            'receiverEmail': userData["email"],
            'receiverID': userData['uid']
          });
        },
      );
    } else {
      return Container();
    }
  }
}

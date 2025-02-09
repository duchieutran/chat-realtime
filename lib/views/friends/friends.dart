import 'package:chatting/services/store_services.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/view_models/friends_vm/friend_viewmodel.dart';
import 'package:chatting/view_models/profile_vm/profile_viewmodel.dart';
import 'package:chatting/views/friends/component/card_info.dart';
import 'package:chatting/views/friends/component/popup_friends.dart';
import 'package:chatting/views/widgets/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:chatting/models/users.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final FriendViewModel friendVM = FriendViewModel();
  final ProfileViewModel profileVM = ProfileViewModel();
  final StoreServices store = StoreServices();
  final TextEditingController searchController = TextEditingController();
  Users? searchedUser;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Friends",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Friends"),
              Tab(text: "Requests"),
              Tab(text: "Search"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFriendsList(),
            _buildFriendRequests(),
            _buildSearchFriends(),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsList() {
    return StreamBuilder<List<String>>(
      stream: store.listenToFriend(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<String> friendIds = snapshot.data!;

        return ListView.builder(
          itemCount: friendIds.length,
          itemBuilder: (context, index) {
            return FutureBuilder<Users?>(
              future: store.getUserInfo(uid: friendIds[index]),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const SizedBox();
                Users user = userSnapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CardInfo(
                    urlAvatar: user.urlAvatar,
                    email: user.email,
                    name: user.name,
                  ),
                );
              },
            );
          },
        );
      },
    );
    ;
  }

  Widget _buildFriendRequests() {
    return StreamBuilder<List<String>>(
      stream: store.listenToFriendRequests(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        List<String> friendRequestIds = snapshot.data!;

        return ListView.builder(
          itemCount: friendRequestIds.length,
          itemBuilder: (context, index) {
            return FutureBuilder<Users?>(
              future: store.getUserInfo(uid: friendRequestIds[index]),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const SizedBox();
                Users user = userSnapshot.data!;
                return CardInfo(
                  urlAvatar: user.urlAvatar,
                  email: user.email,
                  name: user.name,
                  iconData: Icons.check_circle,
                  feature: "Accept",
                  function: () async {
                    await store.acceptFriendRequest(user.uid);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSearchFriends() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextFieldCustom(
            controller: searchController,
            hintText: "Search UID",
            inputType: TextInputType.text,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 160,
          height: 50,
          child: OutlinedButton(
            onPressed: () async {
              if (searchController.text.trim().isEmpty) {
                print("Vui long nhap uid");
              } else {
                Users? user = await friendVM.findFriends(
                    uid: searchController.text.trim());
                if (user == null) {
                  print("nguoi dung khong ton tai!");
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => FriendRequestDialog(
                        url: user.urlAvatar,
                        name: user.name,
                        email: user.email,
                        statusAdd: false,
                        onAddFriend: () {
                          friendVM.sendFriend(
                              receiverUid: searchController.text);
                        }),
                  );
                }
              }
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.blue40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.black.withOpacity(0.2),
              elevation: 3,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: AppColors.light, size: 22),
                SizedBox(width: 8),
                Text(
                  "Search",
                  style: TextStyle(
                    color: AppColors.light,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

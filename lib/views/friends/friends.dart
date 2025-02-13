import 'package:chatting/models/users_model.dart';
import 'package:chatting/services/store_services.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/view_models/chat_vm/message_vm.dart';
import 'package:chatting/view_models/friends_vm/friend_viewmodel.dart';
import 'package:chatting/views/friends/component/card_info.dart';
import 'package:chatting/views/friends/component/popup_friends.dart';
import 'package:chatting/views/widgets/app_dialog.dart';
import 'package:chatting/views/widgets/text_field_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final FriendViewModel friendVM = FriendViewModel();
  final StoreServices store = StoreServices();
  final FirebaseAuth instance = FirebaseAuth.instance;
  final MessageViewModel messageViewModel = MessageViewModel();
  final TextEditingController searchController = TextEditingController();

  void _searchFriend() async {
    String uid = searchController.text.trim();
    if (uid.isEmpty) {
      appDialog(
          context: context,
          title: "Warning!",
          content: "Please enter a valid UID",
          confirmText: "Try Again",
          onConfirm: () {
            Navigator.pop(context);
          });
      return;
    }

    Users? user = await friendVM.findFriends(uid: uid);

    if (user != null) {
      print("a");
      bool? isPending = await friendVM.checkFriends(uid: uid);
      print("isPending : ");
      showDialog(
        context: context,
        builder: (context) => FriendRequestDialog(
          url: user.urlAvatar,
          name: user.name,
          email: user.email,
          statusAdd: isPending,
          onAddFriend:
              isPending ? () {} : () => friendVM.sendFriend(receiverUid: uid),
        ),
      );
    } else {
      appDialog(
          context: context,
          title: "Oops!",
          content: "UID not found!",
          confirmText: "Try Again",
          onConfirm: () {
            Navigator.pop(context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Friends",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColors.dark,
            labelColor: AppColors.light,
            unselectedLabelColor: AppColors.grey50,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppColors.grey60,
              borderRadius: BorderRadius.circular(25),
            ),
            indicatorWeight: 3.0,
            tabs: const [
              Tab(text: 'My Friends'),
              Tab(text: 'Requests'),
              Tab(text: 'Search'),
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

        return friendIds.isEmpty
            ? _buildEmptyState("You have no friends yet!")
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: friendIds.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Users?>(
                    future: store.getUserInfo(uid: friendIds[index]),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) return const SizedBox();
                      Users user = userSnapshot.data!;
                      return CardInfo(
                        urlAvatar: user.urlAvatar,
                        email: user.email,
                        name: user.name,
                      );
                    },
                  );
                },
              );
      },
    );
  }

  Widget _buildFriendRequests() {
    return StreamBuilder<List<String>>(
      stream: store.listenToFriendRequests(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        List<String> friendRequestIds = snapshot.data!;

        return friendRequestIds.isEmpty
            ? _buildEmptyState("No pending friend requests!")
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: friendRequestIds.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Users?>(
                    future: store.getUserInfo(uid: friendRequestIds[index]),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) return const SizedBox();
                      Users user = userSnapshot.data!;
                      bool icon = true;
                      return CardInfo(
                        urlAvatar: user.urlAvatar,
                        email: user.email,
                        name: user.name,
                        iconData: icon ? Icons.check_circle : Icons.downloading,
                        feature: "accept",
                        function: () async {
                          setState(() {
                            icon = false;
                          });
                          await store.acceptFriendRequest(user.uid);
                          messageViewModel.createChatRoom(uidName: user.uid);
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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextFieldCustom(
            controller: searchController,
            hintText: "Enter UID to search",
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _searchFriend,
              icon: const Icon(Icons.search, size: 22),
              label: const Text("Search", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue40,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

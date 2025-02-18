import 'package:chatting/models/users_model.dart';
import 'package:chatting/services/store_services.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/friend_viewmodel.dart';
import 'package:chatting/view_models/message_vm.dart';
import 'package:chatting/views/friends/component/card_friends.dart';
import 'package:chatting/views/friends/component/popup_friends_requests.dart';
import 'package:chatting/views/widgets/app_dialog.dart';
import 'package:chatting/views/widgets/popup_profile.dart';
import 'package:chatting/views/widgets/text_field_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final FriendViewModel friendVM = FriendViewModel();
  final StoreServices store = StoreServices();
  final FirebaseAuth instance = FirebaseAuth.instance;
  final MessageViewModel messageViewModel = MessageViewModel();
  final TextEditingController searchController = TextEditingController();

  Set<String> processingRequests = {};

  // Hàm tìm kiếm bạn bè
  void _searchFriend() async {
    String username = searchController.text.trim();
    // nếu không nhập thì hiện thị thông báo
    if (username.isEmpty) {
      appDialog(
          context: context,
          title: "Warning!",
          content: "Please enter a valid username",
          confirmText: "Try Again",
          onConfirm: () {
            Navigator.pop(context);
          });
      return;
    }
    // Tìm kiếm
    final user = await friendVM.findFriendsUsername(username: username);
    if (user != null) {
      bool? isPending = await friendVM.checkFriends(uid: user.uid);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => FriendRequestDialog(
            url: user.urlAvatar,
            name: user.name,
            email: user.email,
            statusAdd: isPending,
            onAddFriend: isPending
                ? () {}
                : () => friendVM.sendFriend(receiverUid: user.uid),
          ),
        );
      }
    } else {
      if (mounted) {
        appDialog(
            context: context,
            title: "Oops!",
            content: "Username not found!",
            confirmText: "Try Again",
            onConfirm: () {
              Navigator.pop(context);
            });
      }
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

  // Hàm hiển thị danh sách bạn bè
  Widget _buildFriendsList() {
    return StreamBuilder<List<String>>(
      // lắng nghe sự thay đổi bạn bè
      stream: store.listenToFriend(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Image(image: AssetImage(gifLoading)));
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CardFriend(
                          urlAvatar: user.urlAvatar,
                          email: user.email,
                          name: user.name,
                          iconData: Icons.info_outline_rounded,
                          feature: "Info",
                          function: () {
                            showPopUpProfile(
                                context: context,
                                urlAvatar: user.urlAvatar,
                                uid: user.uid,
                                name: user.name,
                                email: user.email);
                          },
                          uid: user.uid,
                        ),
                      );
                    },
                  );
                },
              );
      },
    );
  }

  // Danh sách bạn bè gửi yêu cầu kết bạn
  Widget _buildFriendRequests() {
    return StreamBuilder<List<String>>(
      stream: store.listenToFriendRequests(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Image(image: AssetImage(gifLoading)));
        }
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedOpacity(
                          opacity:
                              processingRequests.contains(user.uid) ? 0.5 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: CardFriend(
                            urlAvatar: user.urlAvatar,
                            email: user.email,
                            name: user.name,
                            iconData: Icons.check_circle,
                            feature: "Accept",
                            function: () async {
                              setState(() {
                                processingRequests.add(user.uid);
                              });
                              await store.acceptFriendRequest(user.uid);
                              messageViewModel.createChatRoom(
                                  uidName: user.uid);
                              setState(() {
                                processingRequests.remove(user.uid);
                              });
                            },
                            uid: user.uid,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
      },
    );
  }

  // Tìm kiếm bạn bè
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

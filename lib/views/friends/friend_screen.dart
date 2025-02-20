import 'package:chatting/models/users_model.dart';
import 'package:chatting/services/store_services.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/message_vm.dart';
import 'package:chatting/views/friends/component/card_friends.dart';
import 'package:chatting/views/friends/component/friend_appbar.dart';
import 'package:chatting/views/widgets/popup_profile.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  // viewmodel
  final StoreServices storeService = StoreServices();
  final MessageViewModel messageViewModel = MessageViewModel();

  // animation
  final Set<String> _processingRequestsIds = {};

  // in app
  int _currentTabIndex = 0;
  final List<String> _tabs = ["Friends", "Requests"];

  @override
  Widget build(BuildContext context) {
    // list tabView
    final List<Widget> tabView = [
      _buildFriendsListView(),
      _buildFriendRequestsListView(),
    ];
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            color: AppColors.light,
          ),
          child: Column(
            children: [
              // app bar
              FriendAppbar(size: size),
              // tab bar
              _buildFriendTabBar(size),
              // dong ke
              Container(
                width: size.width,
                height: 1,
                decoration: const BoxDecoration(color: AppColors.dark),
              ),
              // tab view
              Expanded(
                  child: IndexedStack(
                index: _currentTabIndex,
                children: tabView,
              ))
            ],
          ),
        ),
      ),
    );
  }

  Container _buildFriendTabBar(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15, vertical: 10),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _tabs.length,
          (index) {
            final isSelect = _currentTabIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() => _currentTabIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelect ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  width: size.width * 0.2,
                  child: Center(
                    child: Text(
                      _tabs[index],
                      style: TextStyle(
                        color: isSelect ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // friend
  Widget _buildFriendsListView() {
    return StreamBuilder<List<String>>(
      // lắng nghe sự thay đổi bạn bè
      stream: storeService.listenToFriend(),
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
                    future: storeService.getUserInfo(uid: friendIds[index]),
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

  // friend request
  Widget _buildFriendRequestsListView() {
    return StreamBuilder<List<String>>(
      stream: storeService.listenToFriendRequests(),
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
                    future:
                        storeService.getUserInfo(uid: friendRequestIds[index]),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) return const SizedBox();
                      Users user = userSnapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedOpacity(
                          opacity: _processingRequestsIds.contains(user.uid)
                              ? 0.5
                              : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: CardFriend(
                            urlAvatar: user.urlAvatar,
                            email: user.email,
                            name: user.name,
                            iconData: Icons.check_circle,
                            feature: "Accept",
                            function: () async {
                              setState(() {
                                _processingRequestsIds.add(user.uid);
                              });
                              await storeService.acceptFriendRequest(user.uid);
                              messageViewModel.createChatRoom(
                                  uidName: user.uid);
                              setState(() {
                                _processingRequestsIds.remove(user.uid);
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

import 'package:chatting/models/users.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/view_models/friends/friend_viewmodel.dart';
import 'package:chatting/view_models/profile/profile_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // khai báo
  final ProfileViewModel profileViewModel = ProfileViewModel();
  final FriendViewModel friendViewModel = FriendViewModel();
  late bool isLoading;
  Users users = Users();
  List<Users> listFriend = [];

  @override
  void initState() {
    isLoading = true;
    getUsers();
    super.initState();
  }

  // hàm lấy thông tin user
  getUsers() async {
    try {
      Users? user = await profileViewModel.getUserProfile();
      if (user != null) {
        users = user;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      rethrow;
    }
  }

  // hàm lấy thông tin friend
  getFriends() async {
    try {
      List<Users>? friends = await friendViewModel.getFriend();
      if (friends != null) {
        listFriend = friends;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("profile", style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                  width: size.width,
                  height: size.height * 0.35,
                  decoration: const BoxDecoration(
                    color: AppColors.blue30,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(35),
                      bottomLeft: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.height * 0.1,
                        height: size.height * 0.1,
                        decoration: BoxDecoration(
                          color: AppColors.light,
                          borderRadius: BorderRadius.all(Radius.circular(size.height * 0.1)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(size.height * 0.1)),
                          child: Image.network(
                            users.urlAvatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
                              Text(
                                "${users.friendRequests!.length}",
                                style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(onPressed: () {}, icon: const Icon(Icons.person_add_alt)),
                              Text(
                                "${users.friends!.length}",
                                style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                  width: size.width * 1,
                  height: size.height * 0.55,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey20.withOpacity(0.8),
                          offset: const Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.grey20.withOpacity(0.8),
                          offset: const Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // tên
                        textInfo(title: 'UID :  ', content: users.uid),
                        // email
                        textInfo(title: 'email :  ', content: users.email),
                        // trạng thái hoạt động
                        textInfo(title: 'active :  ', content: users.isOnline ? "Online" : "Offline"),
                        // bạn bè
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: AppColors.red50,
                                  ),
                                  const Text(
                                    "name",
                                    style: TextStyle(
                                      color: AppColors.grey40,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: AppColors.red50,
                                  ),
                                  const Text(
                                    "name",
                                    style: TextStyle(
                                      color: AppColors.grey40,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: AppColors.red50,
                                  ),
                                  const Text(
                                    "name",
                                    style: TextStyle(
                                      color: AppColors.grey40,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: AppColors.red50,
                                  ),
                                  const Text(
                                    "name",
                                    style: TextStyle(
                                      color: AppColors.grey40,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: AppColors.red50,
                                  ),
                                  const Text(
                                    "name",
                                    style: TextStyle(
                                      color: AppColors.grey40,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: AppColors.red50,
                                  ),
                                  const Text(
                                    "name",
                                    style: TextStyle(
                                      color: AppColors.grey40,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: AppColors.red50,
                                  ),
                                  const Text(
                                    "name",
                                    style: TextStyle(
                                      color: AppColors.grey40,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Row textInfo({required String title, required String content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.grey40,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              content,
              style: const TextStyle(
                color: AppColors.dark,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

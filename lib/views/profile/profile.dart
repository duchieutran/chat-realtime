import 'package:chatting/models/users_model.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/friend_viewmodel.dart';
import 'package:chatting/view_models/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final ProfileViewModel profileViewModel = ProfileViewModel();
  final FriendViewModel friendViewModel = FriendViewModel();
  late AnimationController _animationController;
  late bool isLoading;
  Users users = Users();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    isLoading = true;
    getUsers();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  getUsers() async {
    try {
      Users? user = await profileViewModel.getUserProfile();
      if (user != null) {
        setState(() => users = user);
      }
      setState(() => isLoading = false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.light,
      body: isLoading
          ? const Center(child: Image(image: AssetImage(gifLoading)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // appbar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                                // TODO : onTap setting
                              },
                              child: RotationTransition(
                                turns: _animationController,
                                child: const Icon(
                                  Icons.settings,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(users.urlAvatar),
                                ),
                                color: AppColors.blue20,
                                borderRadius: BorderRadius.circular(39),
                                border: Border.all(
                                    color: AppColors.blue40, width: 1),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Avatar & Thông tin
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.blue30,
                      gradient: const LinearGradient(
                        colors: [AppColors.blue40, AppColors.blue60],
                        begin: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey70.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(users.urlAvatar),
                          backgroundColor: AppColors.grey20,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          users.name,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.light),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: users.username));
                          },
                          child: Text(
                            "@${users.username}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.light),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            infoCard("Friends",
                                users.friends!.length.toString(), Icons.person),
                            infoCard(
                                "Requests",
                                users.friendRequests!.length.toString(),
                                Icons.person_add),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Thông tin chi tiết
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey70.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        textInfo(title: "UID  ", content: users.uid),
                        textInfo(title: "Email  ", content: users.email),
                        textInfo(title: "Status  ", content: "Online"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget infoCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.light, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.light),
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              color: AppColors.light,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget textInfo({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.grey40,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: content));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copied UID to clipboard.")));
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  content,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

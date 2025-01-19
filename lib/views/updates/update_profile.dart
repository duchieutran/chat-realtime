import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatting/data_sources/app_colors.dart';
import 'package:chatting/data_sources/themes/themes.dart';
import 'package:chatting/models/entitys/friend_entity.dart';
import 'package:chatting/models/users/users.dart';
import 'package:chatting/view_models/profile/profile_service.dart';
import 'package:chatting/views/widgets/loading_friends.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final ProfileService updateProfile = ProfileService();
  late File image;
  final ImagePicker picker = ImagePicker();
  String? imageUrl;
  late Users users;
  late List<FriendEntity> friend;
  bool isLoading = false;
  bool isLoadAvatar = false; // update avatar

  @override
  void initState() {
    users = Users();
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.bottom),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                // background view trend
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
                  width: double.infinity,
                  height: 310,
                  decoration: const BoxDecoration(
                      color: Colors.black, borderRadius: BorderRadius.only(bottomRight: Radius.circular(230))),
                  child: SizedBox(
                    width: 250.0,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Canterbury',
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText('Xin Chào, ', textStyle: const TextStyle(fontSize: 40)),
                          TypewriterAnimatedText('Bạn có từng nghĩ đây là ứng dụng tuyệt vời không ?'),
                          TypewriterAnimatedText('Nếu bạn nghĩ là có thì bạn đúng rồi đó !!!'),
                          TypewriterAnimatedText('Trải nghiệm ứng dụng và nêu ý kiến góc phải nhé !!!'),
                        ],
                      ),
                    ),
                  ),
                ),

                // info
                Positioned(
                  top: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.blue30,
                              border: Border.all(width: 5, color: AppColors.blue30),
                              borderRadius: BorderRadius.circular(55)),
                          child: CircleAvatar(
                            backgroundColor: AppColors.grey10,
                            backgroundImage: isLoading ? null : (imageUrl == '' ? null : NetworkImage(imageUrl!)),
                            radius: 50,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.grey30,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                                onPressed: pickImage,
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.grey50,
                                  size: 25,
                                )),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      isLoading
                          ? const CircularProgressIndicator() // Hiển thị khi đang tải
                          : Column(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.red,
                                  highlightColor: Colors.yellow,
                                  child: Text(
                                    users.name.isNotEmpty ? users.name : "No Name",
                                    style: const TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Text(
                                  "📩 : ${users.name.isNotEmpty ? users.email : "No email"}",
                                  style: TextStyle(
                                      color: AppColors.dark.withOpacity(1),
                                      fontSize: 20,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Shimmer.fromColors(
                            baseColor: AppColors.dark,
                            highlightColor: AppColors.light,
                            child: const Divider(
                              thickness: 2,
                              color: AppColors.grey70,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 2, right: 2, bottom: 80),
                        width: MediaQuery.of(context).size.width - 10,
                        height: 400,
                        child: ListView(
                          children: const [
                            LoadingFriends(),
                            LoadingFriends(),
                            LoadingFriends(),
                            // LoadingFriends(),
                            // LoadingFriends(),
                            // LoadingFriends(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // loadData
  _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? url = await updateProfile.getURLAvatar();
      Users? user = await updateProfile.getUsers();
      if (user != null) {
        users = user;
        List<String> friendService = user.friends ?? [];
        for (var i = 0; i < friendService.length; i++) {
          Users? tmp = await updateProfile.getUsers();
          if (tmp != null) {
            FriendEntity friendEntity = FriendEntity(email: tmp.email, name: tmp.name, urlAvatar: tmp.urlAvatar);
            friend.add(friendEntity);
          }
        }
      }

      print(url);
      setState(() {
        imageUrl = url;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Ngừng tải nếu gặp lỗi
      });
      rethrow;
    }
  }

  // Chọn ảnh trong thiết bị
  Future<void> pickImage() async {
    try {
      final XFile? pickerFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickerFile != null) {
        setState(() {
          image = File(pickerFile.path);
        });
        // Upload avatar và lấy URL từ Firebase Storage
        updateProfile.updateAvatar(image);

        String? url = await updateProfile.getURLAvatar();
        setState(() {
          imageUrl = url;
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}

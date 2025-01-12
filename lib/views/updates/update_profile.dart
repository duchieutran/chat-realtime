import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatting/data_sources/app_colors.dart';
import 'package:chatting/data_sources/themes/themes.dart';
import 'package:chatting/models/users/users.dart';
import 'package:chatting/view_models/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

List<Color> colorListText = [
  AppColors.blue60,
  AppColors.red60,
  AppColors.green60,
  AppColors.violet60,
  AppColors.blue60,
  AppColors.red60,
  AppColors.green60,
  AppColors.violet60,
  AppColors.blue60,
  AppColors.red60,
  AppColors.green60,
  AppColors.violet60,
];

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final ProfileService updateProfile = ProfileService();
  late File image;
  final ImagePicker picker = ImagePicker();
  String? imageUrl; // Lưu trữ URL của ảnh
  late Users users;
  bool isLoading = false;

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
          color: RiveAppTheme.background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                // background name
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
                  width: double.infinity,
                  height: 310,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(230))),
                  child: SizedBox(
                    width: 250.0,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Canterbury',
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText('Xin Chào, ',
                              textStyle: const TextStyle(fontSize: 40)),
                          TypewriterAnimatedText(
                              'Bạn có từng nghĩ đây là ứng dụng tuyệt vời không ?'),
                          TypewriterAnimatedText(
                              'Nếu bạn nghĩ là có thì bạn đúng rồi đó !!!'),
                          TypewriterAnimatedText(
                              'Trải nghiệm ứng dụng và nêu ý kiến góc phải nhé !!!'),
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
                              border:
                                  Border.all(width: 5, color: AppColors.blue30),
                              borderRadius: BorderRadius.circular(55)),
                          child: CircleAvatar(
                            backgroundColor: AppColors.grey10,
                            backgroundImage: imageUrl !=
                                    null // Kiểm tra nếu có URL
                                ? NetworkImage(imageUrl!) // Hiển thị ảnh từ URL
                                : null, // Không có ảnh, hiển thị ảnh mặc định
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
                      const SizedBox(width: 20),
                      isLoading
                          ? const CircularProgressIndicator() // Hiển thị khi đang tải
                          : AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  users.name.isNotEmpty
                                      ? users.name
                                      : "No Name",
                                  textStyle: const TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  colors: colorListText,
                                ),
                              ],
                              repeatForever: true,
                            ),
                      isLoading
                          ? const CircularProgressIndicator() // Hiển thị khi đang tải
                          : Text(
                              "📩 : ${users.name.isNotEmpty ? users.email : "No email"}",
                              style: TextStyle(
                                  color: AppColors.dark.withOpacity(1),
                                  fontSize: 20,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400),
                              maxLines: 1,
                            ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            thickness: 2,
                            color: AppColors.grey70,
                          ),
                        ),
                      ),
                      if (users.friends != null &&
                          users.friends!.isNotEmpty) ...[
                        const SingleChildScrollView() // TODO : xử lý chỗ này
                      ] else
                        ...[]
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
      setState(() {
        imageUrl = url;
        if (user != null) {
          users = user;
        }
        isLoading = false; // Kết thúc tải
        print(users.friends);
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
      final XFile? pickerFile =
          await picker.pickImage(source: ImageSource.gallery);
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

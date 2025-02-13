import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/profile_vm/profile_viewmodel.dart';
import 'package:chatting/views/widgets/app_button.dart';
import 'package:chatting/views/widgets/app_dialog.dart';
import 'package:chatting/views/widgets/text_field_custom.dart';
import 'package:flutter/material.dart';

class ProfileComplete extends StatefulWidget {
  const ProfileComplete({super.key});

  @override
  State<ProfileComplete> createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete> {
  ProfileViewModel profileViewModel = ProfileViewModel();
  late bool isLoading;
  late bool isLoadingImage;
  late String image;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    isLoadingImage = true;
    image = "";
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  // Update avatar
  updateAvatar() async {
    String url = await profileViewModel.upLoadImage();
    if (url.isNotEmpty) {
      appDialog(
          context: context,
          barrierDismissible: false,
          title: "🎉 Success!",
          content: "Your profile picture has been successfully updated!",
          confirmText: "Okey",
          onConfirm: () {
            Navigator.pop(context);
          });
    }
    setState(() {
      image = url;
    });
  }

  // hàm update thông tin cá nhân.
  void updateProfile() async {
    if (nameController.text.isEmpty || image.isEmpty) {
      // Hiển thị popup lỗi nếu thiếu thông tin
      appDialog(
        context: context,
        title: "⚠️ Error",
        content: "Please update your profile picture and full name.",
        confirmText: "Try Again",
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } else {
      try {
        // Hiển thị popup loading
        appDialog(
            context: context,
            title: "🔄 Loading...",
            content: "Updating your profile...");
        await profileViewModel.updateProfile(
          name: nameController.text,
          image: image,
        );

        // Đóng popup loading
        Navigator.pop(context);

        // Hiển thị thông báo thành công
        appDialog(
            context: context,
            title: "✅ Success!",
            content: "Your profile has been updated successfully.",
            confirmText: "Okey",
            onConfirm: () {
              Navigator.pushNamed(context, AppRouters.home);
            });
      } catch (e) {
        // Đóng popup loading
        Navigator.pop(context);

        // Hiển thị thông báo lỗi
        appDialog(
            context: context,
            title: "❌ Error",
            content: "Failed to update profile. Please try again.",
            confirmText: "Try Again",
            onConfirm: () {
              Navigator.pop(context);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(color: AppColors.blue40),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 200),
                  Container(
                      width: size.width,
                      height: size.height - 200,
                      decoration: const BoxDecoration(
                        color: AppColors.light,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          // tạo field điền tên đăng nhập
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFieldCustom(
                              controller: nameController,
                              textInputAction: TextInputAction.done,
                              inputType: TextInputType.text,
                              hintText: "enter your full name",
                            ),
                          ),
                          // Nút update and -> next,
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: AppButton(
                                    radiusCircular: 12,
                                    onTap: updateProfile,
                                    title: "update",
                                    fontSize: 16,
                                    color: AppColors.light,
                                    backgroundColors: AppColors.blue40,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
              Positioned(
                top: 150,
                left: size.width / 2 - 60,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 5, color: AppColors.green30),
                    borderRadius: const BorderRadius.all(Radius.circular(65)),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: image.isEmpty
                          ? Image.asset(
                              noImage,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              image,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
              // TODO : format lai
              Positioned(
                  top: 240,
                  left: size.width / 2 + 20,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: AppColors.grey30,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: updateAvatar,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

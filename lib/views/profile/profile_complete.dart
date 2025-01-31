import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/profile/profile_viewmodel.dart';
import 'package:chatting/views/widgets/app_button.dart';
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
  late String image;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    isLoading = true;
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
    setState(() {
      image = url;
    });
  }

  // hàm update thông tin cá nhân.
  updateProfile() async {
    if (nameController.text.isNotEmpty) {
      await profileViewModel.updateProfile(name: nameController.text, image: image);
      setState(() {
        isLoading = false;
      });
    } else {
      // TODO : show popup
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
                          // nút upload avt ,
                          SizedBox(
                            width: 180,
                            height: 50,
                            child: AppButton(
                              onTap: updateAvatar,
                              title: "Upload Avatar",
                              fontSize: 16,
                              color: AppColors.light,
                              backgroundColors: AppColors.blue40,
                            ),
                          ),
                          // tạo field điền tên đăng nhập
                          const SizedBox(height: 40),
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
                          const SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: AppButton(
                                    onTap: updateProfile,
                                    title: "update",
                                    fontSize: 16,
                                    color: AppColors.light,
                                    backgroundColors: AppColors.blue40,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: AppButton(
                                    onTap: isLoading
                                        ? () {}
                                        : () {
                                            Navigator.popAndPushNamed(context, AppRouters.home);
                                          },
                                    title: "next >",
                                    fontSize: 16,
                                    color: AppColors.light,
                                    backgroundColors: isLoading ? AppColors.grey30 : AppColors.blue40,
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
                    border: Border.all(width: 5, color: AppColors.light),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

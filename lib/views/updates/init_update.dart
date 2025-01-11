import 'dart:io';

import 'package:chatting/data_sources/app_colors.dart';
import 'package:chatting/view_models/profile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InitUpdateProfile extends StatefulWidget {
  const InitUpdateProfile({super.key});

  @override
  State<InitUpdateProfile> createState() => _InitUpdateProfileState();
}

class _InitUpdateProfileState extends State<InitUpdateProfile> {
  final UpdateProfile updateProfile = UpdateProfile();
  late File image;
  final ImagePicker picker = ImagePicker();
  String? imageUrl; // Lưu trữ URL của ảnh

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      String? url = await updateProfile.getURLAvatar();
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PROFILE",
          style: TextStyle(
              color: AppColors.light,
              fontWeight: FontWeight.w500,
              fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: AppColors.grey40,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.light,
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Stack(children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.blue30,
                    border: Border.all(width: 5, color: AppColors.blue30),
                    borderRadius: BorderRadius.circular(55)),
                child: CircleAvatar(
                  backgroundColor: AppColors.grey10,
                  backgroundImage: imageUrl != null // Kiểm tra nếu có URL
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
            ])
          ],
        ),
      ),
    );
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

import 'dart:io';

import 'package:chatting/models/users_model.dart';
import 'package:chatting/services/pick_image_services.dart';
import 'package:chatting/services/storage_services.dart';
import 'package:chatting/services/store_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel {
  final PickImageServices imageServices = PickImageServices();
  final StorageServices storageServices = StorageServices();
  final StoreServices storeServices = StoreServices();
  final FirebaseAuth auth = FirebaseAuth.instance;

  // func upload ảnh
  Future<String> upLoadImage() async {
    try {
      File? file = await imageServices.pickImage();
      if (file != null) {
        await storageServices.upLoadImage(file);
        String avatar = storageServices.getUrlAvatar();
        return avatar;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  // func update full
  updateProfile({required String name, required String image}) async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      String? email = currentUser.email;
      Users users =
          Users(uid: uid, email: email ?? "", name: name, urlAvatar: image);
      await storeServices.saveUser(user: users);
    }
  }

  // thông tin người dùng
  Future<Users?> getUserProfile() async {
    try {
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        Users? users = await storeServices.getUserInfo(uid: uid);
        if (users != null) {
          return users;
        } else {
          return null;
        }
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}

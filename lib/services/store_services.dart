import 'package:chatting/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreServices {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // lưu thông tin người dùng
  saveUser({required Users user}) async {
    try {
      if (auth.currentUser != null) {
        String uid = auth.currentUser!.uid;
        await fireStore.collection("users").doc(uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.name,
          'urlAvatar': user.urlAvatar,
          'isOnline': user.isOnline,
          'friends': user.friends,
          'friendRequests': user.friendRequests,
        }, SetOptions(merge: true));
      } else {
        print("user không tồn tại!");
      }
    } catch (e) {
      rethrow;
    }
  }

  // lấy thông tin cá nhân theo uid
  Future<Users?> getUserInfo({required String uid}) async {
    try {
      DocumentSnapshot userSnapshot = await fireStore.collection("users").doc(uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        Users user = Users(
          uid: userData['uid'] ?? '',
          email: userData['email'] ?? '',
          name: userData['name'] ?? '',
          urlAvatar: userData['urlAvatar'] ?? '',
          isOnline: userData['isOnline'] ?? false,
          friends: List<String>.from(userData['friends'] ?? []),
          friendRequests: List<String>.from(userData['friendRequests'] ?? []),
        );

        return user;
      } else {
        print("Người dùng không tồn tại trong Firestore !");
        return null;
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin người dùng: $e");
      return null;
    }
  }

  // sửa thông tin người dùng
  modifyUser({required Users user}) async {
    try {
      if (auth.currentUser == null) {
        String uid = auth.currentUser!.uid;
        await fireStore.collection("users").doc(uid).update({
          'uid': uid,
          'email': user.email,
          'name': user.name,
          'urlAvatar': user.urlAvatar,
          'isOnline': user.isOnline,
          'friends': user.friends,
          'friendRequests': user.friendRequests,
        });
      } else {
        print("user khong ton tai");
      }
    } catch (e) {
      rethrow;
    }
  }
}

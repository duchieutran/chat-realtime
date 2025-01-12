import 'dart:io';

import 'package:chatting/models/users/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // cập nhật avatar
  void updateAvatar(File image) async {
    try {
      String fileName = firebaseAuth.currentUser!.uid;
      Reference ref = firebaseStorage.ref().child('profiles/$fileName');
      // Kiểm tra xem file đã tồn tại chưa
      try {
        await ref.getDownloadURL(); // Nếu file tồn tại, sẽ không ném lỗi
        // Nếu file tồn tại, xóa đi
        await ref.delete();
      } catch (e) {
        rethrow;
      }
      // put file
      UploadTask uploadTask = ref.putFile(image);
      // Lấy URL ảnh
      String imageURL = await (await uploadTask).ref.getDownloadURL();
      // cập nhật filestore
      await firebaseFirestore
          .collection("Users")
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'urlAvatar': imageURL,
      });
    } catch (e) {
      rethrow;
    }
  }

  // get avatar
  Future<String?> getURLAvatar() async {
    try {
      DocumentSnapshot documentSnapshot = await firebaseFirestore
          .collection("Users")
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      if (documentSnapshot.exists) {
        String? urlAvatar = documentSnapshot.get('urlAvatar') as String?;
        return urlAvatar;
      }
    } catch (E) {
      rethrow;
    }
    return null;
  }

  // get name data từ firebase theo id
  Future<Users?> getUsers() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await firebaseFirestore
          .collection("Users")
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      if (doc.exists) {
        return Users.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}

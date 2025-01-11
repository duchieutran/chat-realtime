import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileSer {
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
        // Nếu file không tồn tại, không làm gì cả
        print("File không tồn tại, tạo mới.");
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
      print(e.toString());
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
    } on FirebaseFirestore catch (e) {
      print(e.toString());
      rethrow;
    }
    return null;
  }
}

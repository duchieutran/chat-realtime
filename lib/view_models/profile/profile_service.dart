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
      // Lấy UID của người dùng hiện tại
      String fileName = firebaseAuth.currentUser!.uid;
      Reference ref = firebaseStorage.ref().child('profiles/$fileName');

      // Kiểm tra và xóa file nếu đã tồn tại
      try {
        // Kiểm tra xem file có tồn tại không bằng cách lấy URL
        await ref.getDownloadURL();
        // Nếu tồn tại, xóa file cũ
        await ref.delete();
        print('File cũ đã được xóa thành công.');
      } on FirebaseException catch (e) {
        // Nếu file không tồn tại, bỏ qua lỗi này
        if (e.code == 'object-not-found') {
          print('Không có file cũ để xóa.');
        } else {
          // Ném lại các lỗi khác
          print('Lỗi kiểm tra file: ${e.message}');
          rethrow;
        }
      }

      // Tải file mới lên Firebase Storage
      UploadTask uploadTask = ref.putFile(image);
      // Chờ hoàn thành tải lên và lấy URL
      String imageURL = await (await uploadTask).ref.getDownloadURL();
      print('File mới đã được tải lên: $imageURL');

      // Cập nhật URL avatar trong Firestore
      await firebaseFirestore
          .collection("Users")
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'urlAvatar': imageURL,
      });
      print('URL avatar đã được cập nhật trong Firestore.');
    } catch (e) {
      // Xử lý các lỗi khác (nếu có)
      print('Đã xảy ra lỗi: $e');
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

  //get name data từ firebase theo id param
  Future<Users?> getUsersParam({required String uid}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await firebaseFirestore.collection("Users").doc(uid).get();
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

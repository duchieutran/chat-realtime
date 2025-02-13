import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageServices {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String urlAvatar = "";

  // hàm up ảnh lên storage
  upLoadImage(File? file) async {
    try {
      User? user = auth.currentUser;
      if (file != null && user != null) {
        String fileExtension = path.extension(file.path).toLowerCase();
        Reference reference = storage
            .ref()
            .child('/profiles/${user.uid.toString()}$fileExtension');
        UploadTask upload = reference.putFile(file);
        await upload.whenComplete(() async {
          urlAvatar = await reference.getDownloadURL();
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  //lấy ảnh từ firebase
  String getUrlAvatar() => urlAvatar;
}

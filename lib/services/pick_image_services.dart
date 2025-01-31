import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PickImageServices {
  File? imageFile;
  final ImagePicker imagePicker = ImagePicker();

  // chọn ảnh trong máy
  Future<File?> pickImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        imageFile = File(image.path);
        return imageFile;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

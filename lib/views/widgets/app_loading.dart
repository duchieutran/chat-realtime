import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

void appLoading({required BuildContext context, required String gif}) {
  final size = MediaQuery.of(context).size;
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Center(
          child: Image(
            image: AssetImage(gif),
            width: size.width * 0.5,
          ),
        ),
      );
    },
  );
}

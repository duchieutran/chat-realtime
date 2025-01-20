import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final Color color, backgroundColors;
  const AppButton(
      {super.key,
      required this.onTap,
      this.title,
      this.color = AppColors.dark,
      this.backgroundColors = AppColors.brandOrange50});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColors,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(width: 2, color: backgroundColors),
        ),
        child: Center(
          child: Text(
            title ?? "",
            style: TextStyle(
              fontSize: 25,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

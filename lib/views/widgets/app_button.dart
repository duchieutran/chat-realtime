import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final double fontSize;
  final Color color, backgroundColors;
  final double radiusCircular;

  const AppButton(
      {super.key,
      required this.onTap,
      this.title,
      this.fontSize = 25,
      this.radiusCircular = 25,
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
          borderRadius: BorderRadius.all(Radius.circular(radiusCircular)),
          border: Border.all(width: 2, color: backgroundColors),
        ),
        child: Center(
          child: Text(
            title ?? "",
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

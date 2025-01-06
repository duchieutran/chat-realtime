import 'package:chatting/data_sources/app_colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            border: Border.all(
              width: 2,
            )),
        child: const Center(
          child: Text(
            "Button",
            style: TextStyle(
              fontSize: 25,
              color: AppColors.dark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

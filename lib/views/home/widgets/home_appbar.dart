import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar(
      {super.key,
      required this.size,
      required this.onTapLeading,
      required this.onTapAction,
      required this.iconLeading,
      required this.iconAction});

  final Size size;
  final IconData iconLeading;
  final IconData iconAction;
  final VoidCallback onTapLeading;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: size.height * 0.13,
      decoration: const BoxDecoration(
          color: AppColors.violet30,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20), bottom: Radius.circular(20))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // leading
          GestureDetector(
            onTap: onTapLeading,
            child: Icon(
              iconLeading,
              size: size.height * 0.03,
              color: AppColors.light,
            ),
          ),
          // title
          const Text(
            "SayHi",
            style: TextStyle(
              color: AppColors.light,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          // action
          GestureDetector(
            onTap: onTapAction,
            child: Icon(
              iconAction,
              size: size.height * 0.03,
              color: AppColors.light,
            ),
          ),
        ],
      ),
    );
  }
}

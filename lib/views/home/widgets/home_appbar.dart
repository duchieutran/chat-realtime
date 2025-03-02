import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({
    super.key,
    required this.size,
    required this.onTapLeading,
    required this.onTapAction,
    required this.iconLeading,
    required this.iconAction,
    this.notificationCount = 0,
  });

  final Size size;
  final IconData iconLeading;
  final IconData iconAction;
  final VoidCallback onTapLeading;
  final VoidCallback onTapAction;
  final int notificationCount; // Thêm số lượng thông báo

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: size.height * 0.13,
      decoration: const BoxDecoration(
        color: AppColors.violet30,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Leading
          GestureDetector(
            onTap: onTapLeading,
            child: Icon(
              iconLeading,
              size: size.height * 0.03,
              color: AppColors.light,
            ),
          ),
          // Title
          const Text(
            "SayHi",
            style: TextStyle(
              color: AppColors.light,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),

          /// Action với badge thông báo
          GestureDetector(
            onTap: onTapAction,
            child: Stack(
              clipBehavior: Clip.none, // Cho phép badge hiển thị ra ngoài
              children: [
                Icon(
                  iconAction,
                  size: size.height * 0.03,
                  color: AppColors.light,
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DrawerFeature extends StatelessWidget {
  const DrawerFeature({
    super.key,
    required this.size,
    this.onTap,
    required this.icon,
    required this.title,
  });

  final Size size;
  final VoidCallback? onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          highlightColor: AppColors.light,
          onTap: onTap ?? () {},
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            width: size.width * 0.55,
            decoration: const BoxDecoration(
                color: AppColors.blue40,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                )),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 27,
                  color: AppColors.light,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.light,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          width: size.width * 0.55,
          height: 2,
          decoration: const BoxDecoration(
            color: AppColors.grey80,
          ),
        )
      ],
    );
  }
}

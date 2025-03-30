import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class WidgetsCard extends StatelessWidget {
  const WidgetsCard(
      {super.key,
      this.width = 150,
      this.height = 150,
      this.onTap,
      this.color = AppColors.light,
      this.child});
  final double width, height;
  final VoidCallback? onTap;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey40.withOpacity(0.3),
              offset: const Offset(5.0, 5.0),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
            BoxShadow(
              color: AppColors.grey40.withOpacity(0.3),
              offset: const Offset(0.0, 0.0),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ],
        ),
        child: child,
      ),
    );
  }
}

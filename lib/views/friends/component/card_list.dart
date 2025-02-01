import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  const CardList({
    super.key,
    required this.size,
    this.onTap,
    required this.image,
    required this.name,
    required this.email,
  });

  final Size size;
  final VoidCallback? onTap;
  final String image, name, email;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        width: size.width,
        height: size.height * 0.15,
        decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey90.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(3, 3),
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // info
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.grey10,
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            color: AppColors.grey70,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                            color: AppColors.grey70,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ],
                  ),
                )
              ],
            )
            // button
          ],
        ),
      ),
    );
  }
}

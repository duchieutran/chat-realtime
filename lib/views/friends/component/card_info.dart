import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:flutter/material.dart';

class CardInfo extends StatefulWidget {
  const CardInfo({
    super.key,
    this.function,
    required this.urlAvatar,
    required this.email,
    required this.name,
  });

  final VoidCallback? function;
  final String urlAvatar;
  final String email;
  final String name;

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: AppColors.grey40.withOpacity(0.3),
                offset: const Offset(3, 3),
                blurRadius: 6),
            BoxShadow(
                color: AppColors.grey40.withOpacity(0.3),
                offset: const Offset(-3, -3),
                blurRadius: 6),
            BoxShadow(
                color: AppColors.grey40.withOpacity(0.3),
                offset: const Offset(3, -3),
                blurRadius: 6),
            BoxShadow(
                color: AppColors.grey40.withOpacity(0.3),
                offset: const Offset(-3, 3),
                blurRadius: 6)
          ]),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.urlAvatar),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          GestureDetector(
            onTap: widget.function,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.green50,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat,
                    color: AppColors.light,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Chat",
                    style: TextStyle(
                        color: AppColors.light, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

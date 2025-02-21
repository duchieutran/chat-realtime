import 'package:chatting/services/auth_services.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CardFriend extends StatefulWidget {
  const CardFriend({
    super.key,
    this.function,
    required this.urlAvatar,
    required this.username,
    required this.name,
    this.feature,
    this.iconData,
    required this.uid,
  });

  final VoidCallback? function;
  final String uid;
  final String urlAvatar;
  final String username;
  final String name;
  final IconData? iconData;
  final String? feature;

  @override
  State<CardFriend> createState() => _CardFriendState();
}

class _CardFriendState extends State<CardFriend> {
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
          Stack(
            children: [
              Container(
                width: 63,
                height: 63,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.blue40, width: 3)),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.urlAvatar),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: StreamBuilder<bool>(
                    stream: AuthServices().getUserStatus(widget.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        bool isOnline = snapshot.data ?? false;
                        return Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                              color: isOnline
                                  ? AppColors.green50
                                  : AppColors.grey40,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(color: AppColors.light, width: 1)),
                        );
                      } else {
                        return Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                              color: AppColors.grey40,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(color: AppColors.light, width: 1)),
                        );
                      }
                    }),
              )
            ],
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
                  widget.username,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.iconData ?? Icons.chat,
                    color: AppColors.light,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.feature ?? "Chat",
                    style: const TextStyle(
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

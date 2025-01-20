import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:flutter/material.dart';

class LoadingFriends extends StatelessWidget {
  const LoadingFriends({super.key, this.avatarImg, this.name, this.email, this.onPress, this.icon});
  final String? avatarImg;
  final String? name;
  final String? email;
  final VoidCallback? onPress;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 100,
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
            color: AppColors.light,
            border: Border.all(width: 1, color: AppColors.grey10),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: const [BoxShadow(offset: Offset(0, 3), blurRadius: 3, spreadRadius: 4, color: AppColors.grey30)],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(avatarImg ??
                      "https://firebasestorage.googleapis.com/v0/b/instagram-3d6bf.appspot.com/o/profiles%2Fgiaothong.png?alt=media&token=a3eab3be-f43a-4ac9-8d72-84dfbd30564b"),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(name ?? ""), Text(email ?? "")],
                )
              ],
            ),
          ),
        ),
        Positioned(
            top: -2,
            left: -3,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.translate,
              backgroundImage: AssetImage(icon ?? star),
            ))
      ],
    );
  }
}

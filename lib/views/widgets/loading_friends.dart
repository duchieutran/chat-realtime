import 'package:chatting/data_sources/app_colors.dart';
import 'package:chatting/data_sources/assets.dart';
import 'package:flutter/material.dart';

class LoadingFriends extends StatefulWidget {
  const LoadingFriends({super.key});

  @override
  State<LoadingFriends> createState() => _LoadingFriendsState();
}

class _LoadingFriendsState extends State<LoadingFriends> {
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
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 3,
                  spreadRadius: 4,
                  color: AppColors.grey30)
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/instagram-3d6bf.appspot.com/o/profiles%2FFd0PR3Qew4U4GoVekTpKyf5wn3E2?alt=media&token=c6c51653-625c-4287-811e-1502870ca414"),
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Trần Đức Hiếu"),
                    Text("tranduchieu@gmail.com")
                  ],
                )
              ],
            ),
          ),
        ),
        const Positioned(
            top: -2,
            left: -3,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.translate,
              backgroundImage: AssetImage(star),
            ))
      ],
    );
  }
}

import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/view_models/auth_viewmodel.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.grey10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.12),
          // Dang xuat
          DrawerFeature(
              size: size,
              onTap: () {
                AuthViewmodel().logout();
                Navigator.pushReplacementNamed(context, AppRouters.login);
              },
              icon: Icons.logout_outlined,
              title: "Log out"),
          DrawerFeature(size: size, icon: Icons.settings, title: "setting"),
        ],
      ),
    );
  }
}

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

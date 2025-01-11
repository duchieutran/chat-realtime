import 'package:chatting/data_sources/app_colors.dart';
import 'package:chatting/data_sources/app_routers.dart';
import 'package:chatting/view_models/auths/auth_service.dart';
import 'package:flutter/material.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({super.key});

  void logout(BuildContext context) {
    final authView = AuthService();
    authView.logout();
    Navigator.pushNamed(context, AppRouters.login);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // logo
                const DrawerHeader(
                  child: Center(
                    child: Icon(
                      Icons.message,
                      color: AppColors.grey40,
                      size: 40,
                    ),
                  ),
                ),

                // home list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    title: const Text(
                      "H O M E",
                      style: TextStyle(color: AppColors.grey50),
                    ),
                    leading: const Icon(
                      Icons.home,
                      color: AppColors.grey50,
                    ),
                    onTap: () {
                      // pop the draw
                      Navigator.pop(context);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    title: const Text(
                      "S E T T I N G S",
                      style: TextStyle(color: AppColors.grey50),
                    ),
                    leading: const Icon(
                      Icons.settings,
                      color: AppColors.grey50,
                    ),
                    onTap: () {
                      // TODO : onTap to page Settings
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: const Text(
                  "L O G O U T",
                  style: TextStyle(color: AppColors.grey50),
                ),
                leading: const Icon(
                  Icons.logout,
                  color: AppColors.grey50,
                ),
                onTap: () => logout(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/view_models/auth_viewmodel.dart';
import 'package:chatting/view_models/drawer_home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/drawer_future.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, this.isAdmin = true});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final drawerViewModel =
        Provider.of<DrawerHomeViewmodel>(context, listen: true);

    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Color(0xFF001F3F).withOpacity(0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.12),
          // Dang xuat
          DrawerFeature(
              size: size,
              onTap: () {
                drawerViewModel.toggleDrawer();
                AuthViewmodel().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouters.login,
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icons.logout_outlined,
              title: "Log out"),
          // cai dat
          DrawerFeature(size: size, icon: Icons.settings, title: "setting"),
          if (isAdmin) ...[
            DrawerFeature(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouters.admin);
                },
                size: size,
                icon: Icons.admin_panel_settings,
                title: "Admin Panel")
          ],
        ],
      ),
    );
  }
}

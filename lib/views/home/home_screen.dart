import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/drawer_home.dart';
import 'package:chatting/views/home/widgets/home_appbar.dart';
import 'package:chatting/views/home/widgets/home_chatbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/home_carouse_slide.dart';
import 'widgets/home_categoryCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> carouselImages = [carouserImg1, carouserImg2, carouserImg3];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DrawerHome>(
      builder: (context, value, child) => AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(value.isOpen ? 30 : 0),
          ),
          color: AppColors.light,
        ),
        transform: Matrix4.translationValues(value.xOffset, value.yOffset, 0)
          ..scale(value.isOpen ? 0.8 : 1.00)
          ..rotateZ(value.isOpen ? 0.1 : 0),
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            // app bar
            HomeAppbar(
              size: size,
              iconLeading: value.isOpen ? Icons.arrow_back_ios : Icons.menu,
              iconAction: Icons.notifications,
              onTapLeading: () {
                value.toggleDrawer();
              },
              onTapAction: () {},
            ),
            // body
            Container(
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.9)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // slide
                  HomeCarouselSlider(
                      size: size, carouselImages: carouselImages),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HomeCategoryCard(
                          context: context,
                          route: AppRouters.friends,
                          image: friends,
                          title: "Friends"),
                      HomeCategoryCard(
                          context: context,
                          route: AppRouters.profile,
                          image: profiles,
                          title: "Profile"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // box chat
                  HomeChatBox(context: context, image: webChat),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

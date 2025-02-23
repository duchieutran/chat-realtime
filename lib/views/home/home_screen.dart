import 'package:chatting/models/notification_model.dart';
import 'package:chatting/services/notification_service.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/drawer_home_viewmodel.dart';
import 'package:chatting/views/home/widgets/home_appbar.dart';
import 'package:chatting/views/home/widgets/home_chatbox.dart';
import 'package:chatting/views/orther/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
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
    return Consumer<DrawerHomeViewmodel>(
      builder: (context, value, child) => AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(value.isOpen ? 30 : 0),
          ),
          color: AppColors.light,
          boxShadow: value.isOpen
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(-10, 10),
                  ),
                ]
              : [],
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
              onTapAction: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ));
              },
            ),
            // body
            Container(
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // slide
                  HomeCarouselSlider(size: size, carouselImages: carouselImages),
                  FutureBuilder<NotificationModel?>(
                    future: NotificationService().getLatestActiveNotification(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox();
                      }

                      if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                        return SizedBox();
                      }
                      final notification = snapshot.data!;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                          color: AppColors.violet10.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Marquee(
                            text: "🎉 ${notification.content}",
                            style: TextStyle(
                              color: AppColors.dark,
                              fontWeight: FontWeight.bold,
                            ),
                            pauseAfterRound: Duration(seconds: 3),
                            blankSpace: MediaQuery.of(context).size.width,
                          ),
                        ),
                      );
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HomeCategoryCard(context: context, route: AppRouters.friends, image: friends, title: "Friends"),
                      HomeCategoryCard(context: context, route: AppRouters.profile, image: profiles, title: "Profile"),
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

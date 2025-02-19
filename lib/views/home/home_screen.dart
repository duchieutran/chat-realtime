import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/views/widgets/widgets_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> image = [carouserImg1, carouserImg2, carouserImg3];
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(isDrawerOpen ? 30 : 0),
        ),
        color: AppColors.light,
      ),
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.8 : 1.00)
        ..rotateZ(isDrawerOpen ? 0.1 : 0),
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          // app bar
          _buildAppBar(
            size: size,
            iconLeading: isDrawerOpen ? Icons.arrow_back_ios : Icons.menu,
            iconAction: Icons.notifications,
            onTapLeading: () {
              isDrawerOpen
                  ? setState(() {
                      xOffset = 0;
                      yOffset = 0;
                      isDrawerOpen = false;
                    })
                  : setState(() {
                      xOffset = 230;
                      yOffset = 80;
                      isDrawerOpen = true;
                    });
            },
            action: () {},
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: WidgetsCard(
                    width: size.width,
                    height: 300,
                    child: CarouselSlider(
                      items: image.map((img) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            img,
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.85,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryCard(friends, "Friends", AppRouters.friends),
                    _buildCategoryCard(profiles, "Profile", AppRouters.profile),
                    // const SizedBox(height: 20),
                    // Chat Box
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildChatBox(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // app bar
  Widget _buildAppBar({
    required Size size,
    required VoidCallback onTapLeading,
    required VoidCallback action,
    required IconData iconLeading,
    required IconData iconAction,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: size.height * 0.13,
      decoration: const BoxDecoration(
          color: AppColors.violet30,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20), bottom: Radius.circular(20))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // leading
          GestureDetector(
            onTap: onTapLeading,
            child: Icon(
              iconLeading,
              size: size.height * 0.03,
              color: AppColors.light,
            ),
          ),
          // title
          const Text(
            "SayHi",
            style: TextStyle(
              color: AppColors.light,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          // action
          GestureDetector(
            onTap: action,
            child: Icon(
              iconAction,
              size: size.height * 0.03,
              color: AppColors.light,
            ),
          ),
        ],
      ),
    );
  }

  // feature short
  Widget _buildCategoryCard(String image, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 150,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 100),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.blue40,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // feature long
  Widget _buildChatBox() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRouters.chat),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(webChat, height: 80),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chats",
                    style: TextStyle(
                      color: AppColors.blue40,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "Nơi bạn có thể trò chuyện trực tuyến, chia sẻ những câu chuyện với bạn bè của mình hàng ngày.",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

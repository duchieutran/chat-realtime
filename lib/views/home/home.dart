import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatting/services/auth_services.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/views/widgets/widgets_card.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rv;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> image = [carouserImg1, carouserImg2, carouserImg3];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            AuthServices().logout();
            Navigator.popAndPushNamed(context, AppRouters.login);
          },
          icon: const Icon(
            Icons.logout_outlined,
            size: 30,
            color: AppColors.blue40,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "SayHi",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.blue40),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const rv.RiveAnimation.asset(shapesRiv),
          Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Carousel với hiệu ứng đẹp hơn
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

                  // Danh mục chức năng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryCard(
                          friends, "Friends", AppRouters.friends),
                      _buildCategoryCard(
                          profiles, "Profile", AppRouters.profile),
                    ],
                  ),

                  const SizedBox(height: 30),
                  // Chat Box
                  _buildChatBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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

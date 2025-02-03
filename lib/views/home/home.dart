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
              Icons.menu,
              size: 30,
              color: AppColors.blue40,
            )),
        backgroundColor: AppColors.light,
        centerTitle: true,
        title: const Text(
          "SayHi",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.blue40),
        ),
      ),
      body: SizedBox(
        width: size.width,
        child: Stack(children: [
          const rv.RiveAnimation.asset(
            shapesRiv,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color(0xC7FFFFFF),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // carouseSlider banner
                    WidgetsCard(
                      width: size.width,
                      height: 340,
                      child: CarouselSlider(
                        items: image.map((img) {
                          return Image.asset(
                            img,
                            fit: BoxFit.fill,
                          );
                        }).toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // community
                        WidgetsCard(
                          onTap: () {
                            Navigator.pushNamed(context, AppRouters.friends);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                friends,
                                height: 100,
                              ),
                              const Text(
                                "friends",
                                style: TextStyle(color: AppColors.blue40, fontSize: 16, fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                        ),

                        // profile
                        WidgetsCard(
                          onTap: () {
                            Navigator.pushNamed(context, AppRouters.profile);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                profiles,
                                height: 100,
                              ),
                              const Text(
                                "profiles",
                                style: TextStyle(color: AppColors.blue40, fontSize: 16, fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    WidgetsCard(
                        width: size.width,
                        onTap: () {
                          Navigator.pushNamed(context, AppRouters.chat);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(webChat),
                              const Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.visible,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}

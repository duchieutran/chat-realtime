import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatting/views/widgets/widgets_card.dart';
import 'package:flutter/material.dart';

class HomeCarouselSlider extends StatelessWidget {
  const HomeCarouselSlider({
    super.key,
    required this.size,
    required this.carouselImages,
  });

  final Size size;
  final List<String> carouselImages;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: WidgetsCard(
        width: size.width,
        height: 300,
        child: CarouselSlider(
          items: carouselImages.map((img) {
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
    );
  }
}

import 'package:chatting/views/home/home_drawer.dart';
import 'package:chatting/views/home/home_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomeDrawer(),
          HomeScreen(),
        ],
      ),
    );
  }
}

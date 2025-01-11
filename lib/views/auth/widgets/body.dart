import 'dart:async';

import 'package:chatting/data_sources/app_colors.dart';
import 'package:chatting/views/widgets/app_button.dart';
import 'package:flutter/material.dart';

import 'land.dart';
import 'rounded_text_field.dart';
import 'sun.dart';
import 'tabs.dart';

class BodyAuths extends StatefulWidget {
  const BodyAuths(
      {super.key,
      required this.onTapSubmit,
      required this.title,
      required this.onTapNextPage,
      required this.titleNextPage,
      required this.email,
      required this.pass});
  final VoidCallback onTapSubmit;
  final VoidCallback onTapNextPage;
  final String title;
  final String titleNextPage;
  final TextEditingController email;
  final TextEditingController pass;

  @override
  _BodyAuthsState createState() => _BodyAuthsState();
}

class _BodyAuthsState extends State<BodyAuths> {
  bool isFullSun = false;
  bool isDayMood = true;
  final Duration _duration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isFullSun = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeMood(int activeTabNum) {
    if (activeTabNum == 0) {
      setState(() {
        isDayMood = true;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isFullSun = true;
        });
      });
    } else {
      setState(() {
        isFullSun = false;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isDayMood = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> lightBgColors = <Color>[
      const Color(0xFF8C2480),
      const Color(0xFFCE587D),
      const Color(0xFFFF9485),
      if (isFullSun) const Color(0xFFFF9D80),
    ];
    var darkBgColors = [
      const Color(0xFF0D1441),
      const Color(0xFF283584),
      const Color(0xFF376AB2),
    ];
    return AnimatedContainer(
      duration: _duration,
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDayMood ? lightBgColors : darkBgColors,
        ),
      ),
      child: Stack(
        children: [
          Sun(duration: _duration, isFullSun: isFullSun),
          const Land(),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 50),
                      Tabs(
                        press: (value) {
                          changeMood(value);
                        },
                      ),
                      const SizedBox(height: 25),
                      Text(
                        widget.title,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter your Information's below",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 50),
                      RoundedTextField(
                        hintText: "Email",
                        controller: widget.email,
                      ),
                      const SizedBox(height: 25),
                      RoundedTextField(
                        hintText: "Password",
                        controller: widget.pass,
                      ),
                      const SizedBox(height: 35),
                      AppButton(
                        onTap: widget.onTapSubmit,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: widget.onTapNextPage,
                        child: Center(
                          child: Text(
                            widget.titleNextPage,
                            style: const TextStyle(
                              color: AppColors.dark,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

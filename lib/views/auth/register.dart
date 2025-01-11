import 'dart:async';

import 'package:chatting/data_sources/app_colors.dart';
import 'package:chatting/data_sources/app_routers.dart';
import 'package:chatting/view_models/auths/auth_service.dart';
import 'package:chatting/views/widgets/app_button.dart';
import 'package:flutter/material.dart';

import 'widgets/changeMode.dart';
import 'widgets/land.dart';
import 'widgets/rounded_text_field.dart';
import 'widgets/sun.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isFullSun = false;
  bool isDayMood = true;
  final Duration _duration = const Duration(seconds: 1);
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;

  @override
  void initState() {
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isFullSun = true;
      });
    });
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void changeMood(bool change) {
    if (change) {
      setState(() {
        isDayMood = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          isFullSun = true;
        });
      });
    } else {
      setState(() {
        isFullSun = false;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
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
    return Scaffold(
      body: AnimatedContainer(
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
                        const SizedBox(height: 25),
                        Text(
                          "Register",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Enter your Information's below",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 50),
                        RoundedTextField(
                          hintText: "Name",
                          controller: name,
                        ),
                        const SizedBox(height: 20),
                        RoundedTextField(
                          hintText: "Email",
                          controller: email,
                        ),
                        const SizedBox(height: 25),
                        RoundedTextField(
                          obscureText: true,
                          hintText: "Password",
                          controller: password,
                        ),
                        const SizedBox(height: 35),
                        AppButton(
                          title: "Register",
                          color: AppColors.light,
                          onTap: register,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRouters.login);
                          },
                          child: const Center(
                            child: Text(
                              "Already have an account? Log in now.",
                              style: TextStyle(
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
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: IconChangeMode(
                onPressed: (bool value) {
                  changeMood(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  register() {
    final auth = AuthService();
    try {
      auth.register(
          name: name.text, email: email.text, password: password.text);
      Navigator.pushNamedAndRemoveUntil(
          context, AppRouters.home, (Route<dynamic> route) => false);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }
}

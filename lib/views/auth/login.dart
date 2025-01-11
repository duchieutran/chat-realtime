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

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isFullSun = false;
  bool isDayMood = true;
  final Duration _duration = const Duration(seconds: 1);
  final AuthService authViews = AuthService();
  late TextEditingController email;
  late TextEditingController password;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isFullSun = true;
        });
      }
    });
  }

  @override
  void dispose() {
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
      resizeToAvoidBottomInset: true, // giúp không bị tràn màn hình
      body: SingleChildScrollView(
        child: AnimatedContainer(
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
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 50),
                        // Tabs(
                        //   press: (value) {
                        //     changeMood(value);
                        //   },
                        // ),

                        const SizedBox(height: 25),
                        Text(
                          "Login",
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
                        const SizedBox(height: 25),
                        RoundedTextField(
                          hintText: "email",
                          controller: email,
                        ),
                        RoundedTextField(
                          obscureText: true,
                          hintText: "password",
                          controller: password,
                        ),

                        const SizedBox(height: 35),
                        AppButton(
                          title: "Login",
                          color: AppColors.light,
                          onTap: () => login(),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRouters.register);
                          },
                          child: const Center(
                            child: Text(
                              "Don't have an account? Sign up now.",
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
      ),
    );
  }

  // func login
  void login() async {
    final auth = AuthService();
    try {
      await auth.signIn(email: email.text, password: password.text);
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
    // show popup
    // navigator page
  }
}

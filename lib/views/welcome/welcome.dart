import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // khai bao
  AuthProvider authProvider = AuthProvider();

  //init
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 5));
      await authProvider.checkAuthState();
      final router = routerName(authProvider.isAuthenticated);
      if (mounted) Navigator.popAndPushNamed(context, router);
    });

    super.initState();
  }

  // phân màn
  String routerName(int status) {
    switch (status) {
      case 0:
        return AppRouters.login;
      case 1:
        return AppRouters.updateProfile;
      case 2:
        return AppRouters.home;
      default:
        return AppRouters.welcome;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [AppColors.violet50, AppColors.blue40]),
        ),
        child: Column(
          children: [
            // image
            SizedBox(
              width: size.width,
              height: size.height * 0.35,
              child: Center(child: SvgPicture.asset(welcome)),
            ),
            //content
            Container(
              height: size.height * 0.65,
              width: size.width,
              decoration: const BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage(logo),
                    width: size.width * 0.8,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Good Morning,\nHow are you today ?",
                    style: TextStyle(
                        color: AppColors.red50,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  const Image(image: AssetImage(gifLoading))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

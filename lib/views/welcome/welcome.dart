import 'package:action_slider/action_slider.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/view_models/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ActionSlider.standard(
            toggleColor: AppColors.blue40,
            backgroundColor: AppColors.light,
            child: const Text(
              'Welcome to SayHi ...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            action: (controller) async {
              controller.loading();
              await Future.delayed(const Duration(seconds: 3));
              controller.success();
              await authProvider.checkAuthState();
              final router = (authProvider.isAuthenticated)
                  ? AppRouters.home
                  : AppRouters.login;
              await Future.delayed(const Duration(seconds: 1));
              if (!context.mounted) return;
              Navigator.popAndPushNamed(context, router);
            },
          ),
        ),
      ),
    );
  }
}

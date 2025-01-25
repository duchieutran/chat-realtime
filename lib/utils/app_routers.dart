import 'package:chatting/views/auth/login.dart';
import 'package:chatting/views/auth/signup.dart';
import 'package:chatting/views/home/home.dart';
import 'package:chatting/views/profile/profile.dart';
import 'package:chatting/views/welcome/welcome.dart';
import 'package:flutter/material.dart';

class AppRouters {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => makeRoute(
        nameRouters: settings.name!,
        context: context,
        arguments: settings.arguments,
      ),
    );
  }

  static makeRoute({required String nameRouters, required BuildContext context, Object? arguments}) {
    switch (nameRouters) {
      case welcome:
        return const Welcome();
      case login:
        return const Login();
      case signup:
        return const SignUp();
      case home:
        return const Home();
      case profile:
        return const Profile();
      default:
        throw "$nameRouters is not define";
    }
  }

  static const String welcome = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String chat = '/chat';
}

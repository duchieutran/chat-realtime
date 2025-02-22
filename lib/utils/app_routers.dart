import 'package:chatting/views/admin_cpanel/admin_cpanel.dart';
import 'package:chatting/views/auth/login.dart';
import 'package:chatting/views/auth/signup.dart';
import 'package:chatting/views/chat/chat_screen.dart';
import 'package:chatting/views/friends/friend_screen.dart';
import 'package:chatting/views/home/home.dart';
import 'package:chatting/views/profile/profile.dart';
import 'package:chatting/views/profile/profile_complete.dart';
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

  static makeRoute(
      {required String nameRouters,
      required BuildContext context,
      Object? arguments}) {
    switch (nameRouters) {
      case welcome:
        return const Welcome();
      case login:
        return const Login();
      case signup:
        return const SignUp();
      case updateProfile:
        return const ProfileComplete();
      case home:
        return const Home();
      case profile:
        return const Profile();
      case friends:
        // return const Friends();
        return const FriendScreen();
      case chat:
        return const ChatScreen();
      case admin:
        return const AdminCpanel();
      default:
        throw "$nameRouters is not define";
    }
  }

  static const String welcome = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String updateProfile = '/profileComplete';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String friends = '/friends';
  static const String chat = '/chat';
  static const String admin = '/admin';
}

import 'package:chatting/views/auth/login.dart';
import 'package:chatting/views/auth/signup.dart';
import 'package:chatting/views/chat/chat_message.dart';
import 'package:chatting/views/chat/chat_screen.dart';
import 'package:chatting/views/updates/update_profile.dart';
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
      case splash: // TODO : test
        return const Login();
      case login:
        return const Login();
      case signup:
        return const SignUp();
      case home:
        return const ChatScreen();
      case updateProfile:
        return const UpdateProfile();
      case chat:
        if (arguments is Map<String, dynamic>) {
          return ChatPage(
            receiverEmail: arguments['receiverEmail'] as String,
            receiverID: arguments['receiverID'] as String,
          );
        }

      default:
        throw "$nameRouters is not define";
    }
  }

  static const String splash = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String updateProfile = '/updateProfile';
  static const String chat = '/chat';
}

import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/themes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouters.onGenerateRoute,
      // initialRoute: AppRouters.login,
      // home: const AuthGate(),
    );
  }
}

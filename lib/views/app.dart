import 'package:chatting/data_sources/app_routers.dart';
import 'package:chatting/data_sources/themes/themes.dart';
import 'package:chatting/views/auth/auth_gate.dart';
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

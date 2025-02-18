import 'package:chatting/services/auth_services.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/themes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AuthServices().setIsOnline();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AuthServices().setOffline();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AuthServices().setIsOnline();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      AuthServices().setOffline();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouters.onGenerateRoute,
      initialRoute: AppRouters.welcome,
    );
  }
}

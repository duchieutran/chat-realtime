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
    // Lắng nghe sự thay đổi vòng đời ứng dụng
    WidgetsBinding.instance.addObserver(this);
    // Đặt trạng thái là online khi ứng dụng được khởi chạy
    AuthServices().setIsOnline();
  }

  @override
  void dispose() {
    // Xóa observer khi widget bị hủy
    WidgetsBinding.instance.removeObserver(this);
    // Đặt trạng thái offline khi người dùng thoát app
    AuthServices().setOffline();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Khi ứng dụng mở lại từ background, đặt online
      AuthServices().setIsOnline();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Khi ứng dụng chuyển sang background hoặc đóng, đặt offline
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

import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/view_models/auth_provider.dart';
import 'package:chatting/view_models/drawer_home_viewmodel.dart';
import 'package:chatting/view_models/message_vm.dart';
import 'package:chatting/view_models/profile_viewmodel.dart';
import 'package:chatting/views/app.dart';
import 'package:chatting/views/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Khởi tạo firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Ẩn thanh trạng thái
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent, // Làm trong suốt thanh trạng thái
      statusBarIconBrightness: Brightness.light, // Biểu tượng màu sáng
    ),
  );

  // run App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MessageViewModel()),
        ChangeNotifierProvider(create: (context) => DrawerHomeViewmodel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel())
      ],
      child: const MyApp(),
    ),
  );
}

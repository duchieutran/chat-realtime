import 'package:chatting/view_models/auths_vm/auth_provider.dart';
import 'package:chatting/view_models/chat_vm/message.dart';
import 'package:chatting/views/firebase_options.dart';
import 'package:chatting/views/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Khởi tạo firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageViewModel(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

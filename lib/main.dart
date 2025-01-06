import 'package:chatting/firebase_options.dart';
import 'package:chatting/view_models/auths/authsview.dart';
import 'package:chatting/views/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViews(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

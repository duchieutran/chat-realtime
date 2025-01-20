import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // 1. Light Theme
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.light, // màu chính của app
      scaffoldBackgroundColor: AppColors.light, // màu
      appBarTheme: const AppBarTheme(
        color: AppColors.blue30,
      ),
      fontFamily: 'Quicksand');

  // 2. Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );
}

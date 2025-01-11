import 'package:chatting/data_sources/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: AppColors.grey30,
    primary: AppColors.grey50,
    secondary: AppColors.grey20,
    tertiary: AppColors.light,
    inversePrimary: AppColors.grey90,
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: AppColors.grey30,
    primary: AppColors.grey50,
    secondary: AppColors.grey20,
    tertiary: AppColors.light,
    inversePrimary: AppColors.grey90,
  ),
);

class RiveAppTheme {
  static const Color accentColor = Color(0xFF5E9EFF);
  static const Color shadow = Color(0xFF4A5367);
  static const Color shadowDark = Color(0xFF000000);
  static const Color background = Color(0xFFF2F6FF);
  static const Color backgroundDark = Color(0xFF25254B);
  static const Color background2 = Color(0xFF17203A);
}

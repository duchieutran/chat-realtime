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

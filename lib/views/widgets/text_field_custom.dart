import 'package:chatting/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom(
      {super.key,
      required this.controller,
      this.onChanged,
      this.inputType = TextInputType.text,
      this.hintText = '',
      this.obscureText = false,
      this.textInputAction = TextInputAction.next,
      this.errorText});

  final TextEditingController controller;
  final TextInputType inputType;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,

      style: const TextStyle(fontSize: 18, color: Colors.black),
      textAlign: TextAlign.left,
      textInputAction: textInputAction,
      keyboardType: inputType,
      obscureText: obscureText,
      // ẩn hiện password
      decoration: InputDecoration(
        errorText: errorText,
        contentPadding: const EdgeInsets.only(
            left: 15.0, top: 15.0, right: 10.0, bottom: 17.0),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: AppColors.grey40, fontWeight: FontWeight.w400, fontSize: 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: AppColors.blue30, width: 2), // Màu khi Focus
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: AppColors.grey40, width: 2), // Màu mặc định
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.red50, width: 2), // Màu khi lỗi
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.red40, width: 2), // Màu khi lỗi và focus
        ),
      ),
    );
  }
}

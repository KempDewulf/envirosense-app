import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.whiteColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.accentColor),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(color: AppColors.whiteColor),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.whiteColor)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.whiteColor)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.secondaryColor)),
        suffixIcon: suffixIcon,
      ),
      keyboardType: TextInputType.text,
    );
  }
}

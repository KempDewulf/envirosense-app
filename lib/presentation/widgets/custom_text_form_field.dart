import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: AppColors.whiteColor,
      style: const TextStyle(color: AppColors.whiteColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.accentColor),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(color: AppColors.whiteColor),
        border: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.whiteColor)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor)),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        suffixIcon: suffixIcon,
      ),
      keyboardType: TextInputType.text,
      validator: validator,
      focusNode: focusNode,
    );
  }
}

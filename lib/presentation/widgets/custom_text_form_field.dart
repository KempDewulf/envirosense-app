import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.focusNode,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.whiteColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.secondaryColor),
        border: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor),),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor),),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor, width: 2),),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(color: AppColors.whiteColor),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      validator: validator,
      focusNode: focusNode,
    );
  }
}

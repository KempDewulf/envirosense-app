import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class CustomSnackbar {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.secondaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/services/auth_service.dart';

class SignOutDialog extends StatelessWidget {
  final AuthService _authService = AuthService();

  SignOutDialog({super.key});

  void _handleSignOut(BuildContext context) async {
    try {
      await _authService.signOut(context);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryColor,
      title: const Text(
        'Sign Out',
        style: TextStyle(color: AppColors.whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Are you sure you want to sign out?',
        style: TextStyle(
          color: AppColors.whiteColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.accentColor),
          ),
        ),
        FilledButton(
          onPressed: () => _handleSignOut(context),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
          ),
          child: const Text(
            'Yes, Sign Out',
            style: TextStyle(color: AppColors.whiteColor),
          ),
        ),
      ],
    );
  }
}

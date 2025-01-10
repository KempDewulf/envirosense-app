import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/services/auth_service.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final AuthService _authService = AuthService();

  ForgotPasswordDialog({super.key});

  void _handleResetPassword(BuildContext context) async {
    try {
      String? userEmail = _authService.getCurrentUser()?.email;

      await _authService.resetPassword(userEmail!);

      if (!context.mounted) return;

      await _authService.signOut(context);

      if (!context.mounted) return;

      Navigator.pop(context);
      CustomSnackbar.showSnackBar(
        context,
        'Password reset email sent. Please check your inbox.',
      );
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showSnackBar(
          context,
          'Failed to send reset email. Please try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryColor,
      title: const Text(
        'Reset Password',
        style: TextStyle(color: AppColors.whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Are you sure you want to receive an email for resetting your password?',
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
          onPressed: () => _handleResetPassword(context),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
          ),
          child: const Text(
            'Yes, Send Email',
            style: TextStyle(color: AppColors.whiteColor),
          ),
        ),
      ],
    );
  }
}

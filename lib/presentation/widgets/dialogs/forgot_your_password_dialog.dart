import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/services/auth_service.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final bool askEmail;

  const ForgotPasswordDialog({
    super.key,
    this.askEmail = false,
  });

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword(BuildContext context) async {
    try {
      String? emailToReset;

      if (widget.askEmail) {
        emailToReset = _emailController.text.trim();
        if (emailToReset.isEmpty) {
          throw Exception('Please enter an email');
        }
      } else {
        emailToReset = _authService.getCurrentUser()?.email;
        if (emailToReset == null) {
          throw Exception('No email found');
        }
      }

      await _authService.resetPassword(emailToReset);

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to receive an email for resetting your password?',
            style: TextStyle(
              color: AppColors.whiteColor,
            ),
          ),
          if (widget.askEmail) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: AppColors.whiteColor),
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: AppColors.lightGrayColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightGrayColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accentColor),
                ),
              ),
            ),
          ],
        ],
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

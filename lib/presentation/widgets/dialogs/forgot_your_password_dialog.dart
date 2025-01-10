import 'package:envirosense/presentation/widgets/core/custom_text_form_field.dart';
import 'package:envirosense/services/validation_service.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) return;

      String? emailToReset;
      bool wasSignedIn = _authService.getCurrentUser() != null;

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

      Navigator.pop(context); // Close dialog

      if (wasSignedIn) await _authService.signOut(context);
      if (!context.mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        wasSignedIn ? 'Password reset email sent. Please login again with your new password.' : 'Password reset email sent. Please check your inbox.',
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
      content: Form(
        // Wrap content in Form
        key: _formKey,
        child: Column(
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
              CustomTextFormField(
                controller: _emailController,
                labelText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: ValidationService.validateEmail,
                textStyle: const TextStyle(color: AppColors.whiteColor),
                labelColor: AppColors.whiteColor,
                borderColor: AppColors.lightGrayColor,
                focusColor: AppColors.accentColor,
              ),
            ],
          ],
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

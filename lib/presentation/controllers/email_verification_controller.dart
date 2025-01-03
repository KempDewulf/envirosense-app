import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkEmailVerified(BuildContext context) async {
    await _auth.currentUser?.reload();
    final user = _auth.currentUser;

    if (context.mounted) {
      if (user != null && user.emailVerified) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        CustomSnackbar.showSnackBar(
          context,
          'Email not verified yet. Please check your inbox.',
        );
      }
    }
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      if (context.mounted) {
        CustomSnackbar.showSnackBar(
          context,
          'Verification email resent. Please check your inbox.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showSnackBar(
          context,
          'Failed to resend email. Try again later.',
        );
      }
    }
  }

  Future<void> cancelRegistration(BuildContext context) async {
    await _auth.currentUser?.delete();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}

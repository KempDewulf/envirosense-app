import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkEmailVerified(BuildContext context) async {
    await _auth.currentUser?.reload();
    final user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not verified yet. Please check your inbox.'),
        ),
      );
    }
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email resent. Please check your inbox.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to resend email. Try again later.'),
        ),
      );
    }
  }

  Future<void> cancelRegistration(BuildContext context) async {
    await _auth.currentUser?.delete();
    Navigator.pushReplacementNamed(context, '/login');
  }
}

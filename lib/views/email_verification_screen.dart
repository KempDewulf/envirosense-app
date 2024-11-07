import 'package:envirosense/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isChecking = false;
  bool _canResendEmail = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _canResendEmail = true;
        });
      }
    });
  }

  Future<void> _checkEmailVerified() async {
    setState(() {
      _isChecking = true;
    });

    await _auth.currentUser?.reload();
    final user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      setState(() {
        _isChecking = false;
      });
      _showMessage('Email not verified yet. Please check your inbox.');
    }
  }

  Future<void> _resendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      _showMessage('Verification email resent. Please check your inbox.');

      setState(() {
        _canResendEmail = false;
      });

      Future.delayed(const Duration(seconds: 30), () {
        if (mounted) {
          setState(() {
            _canResendEmail = true;
          });
        }
      });
    } catch (e) {
      _showMessage('Failed to resend email. Try again later.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.primaryColor),
        ),
        backgroundColor: AppColors.whiteColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _cancelRegistration() async {
    await _auth.currentUser?.delete();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.primaryColor, // Set primary color as background
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Informational Text
            Text(
              'A verification email has been sent to ${widget.email}.',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.whiteColor, // Set text color to white
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // "I Verified My Email" Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isChecking ? null : _checkEmailVerified,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor, // Orange color
                  foregroundColor: AppColors.whiteColor, // White text
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Small rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isChecking
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                      )
                    : const Text(
                        'I Verified My Email',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // "Resend Verification Email" Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _canResendEmail ? _resendVerificationEmail : null,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.whiteColor, // White background
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Small rounded corners
                    side: const BorderSide(
                      color: AppColors.secondaryColor, // Optional: add border
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _canResendEmail
                    ? const Text(
                        'Resend Verification Email',
                        style: TextStyle(color: AppColors.primaryColor),
                      )
                    : const Text(
                        'You can resend the email in 30 seconds.',
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _cancelRegistration,
                child: const Text(
                  'Cancel Registration',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

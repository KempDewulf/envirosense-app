import 'package:envirosense/presentation/controllers/email_verification_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final EmailVerificationController _controller = EmailVerificationController();
  bool _isChecking = false;
  bool _canResendEmail = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
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
    await _controller.checkEmailVerified(context);
    setState(() {
      _isChecking = false;
    });
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _canResendEmail = false;
    });
    await _controller.resendVerificationEmail(context);
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _canResendEmail = true;
        });
      }
    });
  }

  Future<void> _cancelRegistration() async {
    await _controller.cancelRegistration(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.verificationEmailSent(widget.email),
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.whiteColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isChecking ? null : _checkEmailVerified,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  foregroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isChecking
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                      )
                    : Text(
                        l10n.verifiedEmailButton,
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _canResendEmail ? _resendVerificationEmail : null,
              child: Text(
                l10n.resendVerificationEmail,
                style: TextStyle(
                  color: _canResendEmail ? AppColors.whiteColor : AppColors.lightGrayColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _cancelRegistration,
              child: Text(
                l10n.cancelRegistration,
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

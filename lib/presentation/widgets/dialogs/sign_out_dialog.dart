import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        l10n.signOut,
        style: TextStyle(color: AppColors.whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(
        l10n.signOutConfirm,
        style: TextStyle(
          color: AppColors.whiteColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: AppColors.accentColor),
          ),
        ),
        FilledButton(
          onPressed: () => _handleSignOut(context),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
          ),
          child: Text(
            l10n.yesSignOut,
            style: TextStyle(color: AppColors.whiteColor),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Text(
          'Settings Page',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.accentColor,
          ),
        ),
      ),
    );
  }
}
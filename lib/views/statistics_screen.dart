import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Statistics Page',
        style: TextStyle(
          fontSize: 24,
          color: AppColors.accentColor,
        ),
      ),
    );
  }
}

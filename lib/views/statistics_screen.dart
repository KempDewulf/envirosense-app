import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Text(
          'Statistics Page',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.accentColor,
          ),
        ),
      ),
    );
  }
}

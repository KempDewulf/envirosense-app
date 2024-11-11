// lib/views/statistics_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class StatisticsDetailScreen extends StatelessWidget {
  const StatisticsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics Detail'),
        backgroundColor: AppColors.accentColor,
      ),
      body: Center(
        child: Text(
          'Detailed Statistics Information',
          style: TextStyle(fontSize: 18, color: AppColors.blackColor),
        ),
      ),
    );
  }
}

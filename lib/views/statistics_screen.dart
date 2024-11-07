import 'package:envirosense/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<StatisticsScreen> {
  int _selectedBottomNavIndex = 0;

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/homescreen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/statistics');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: const Center(
        child: Text(
          'Statistics Page',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.accentColor,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedBottomNavIndex, onTap: _onBottomNavTap),
    );
  }
}

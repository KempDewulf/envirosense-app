// header.dart

import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/tab_button.dart';

class Header extends StatelessWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;

  const Header({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Howest University',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.accentColor,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                'Campus Brugge Station - Building A',
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TabButton(
                text: 'ROOMS',
                isSelected: selectedTabIndex == 0,
                onTap: () => onTabSelected(0),
              ),
              const SizedBox(width: 32),
              TabButton(
                text: 'DEVICES',
                isSelected: selectedTabIndex == 1,
                onTap: () => onTabSelected(1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

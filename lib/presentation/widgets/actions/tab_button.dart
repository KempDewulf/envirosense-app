// tab_button.dart

import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.whiteColor : AppColors.accentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 4,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 4,
                width: 60,
                color: isSelected ? AppColors.secondaryColor : Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
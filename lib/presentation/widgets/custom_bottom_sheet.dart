import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
          content,
          Divider(color: AppColors.accentColor.withOpacity(0.2)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: actions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

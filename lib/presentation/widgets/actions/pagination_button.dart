import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';

class PaginationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isNext;
  final String text;

  const PaginationButton({
    super.key,
    required this.onPressed,
    required this.isNext,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryColor,
        foregroundColor: AppColors.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isNext) const Icon(Icons.chevron_left, size: 20),
          Text(text),
          if (isNext) const Icon(Icons.chevron_right, size: 20),
        ],
      ),
    );
  }
}

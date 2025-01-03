import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Page $currentPage of $totalPages',
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.accentColor,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomSheetHeader extends StatelessWidget {
  final String title;

  const CustomBottomSheetHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class LanguageOptionItem extends StatelessWidget {
  final String code;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOptionItem({
    super.key,
    required this.code,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.secondaryColor.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CountryFlag.fromLanguageCode(
                code,
                height: 24,
                width: 24,
                shape: Circle(),
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.secondaryColor : AppColors.primaryColor,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  color: AppColors.secondaryColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

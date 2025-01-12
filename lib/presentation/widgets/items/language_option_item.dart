import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';
import '../models/language_option.dart';
import 'package:country_flags/country_flags.dart';

class LanguageOptionItem extends StatelessWidget {
  final LanguageOption option;
  final VoidCallback onTap;

  const LanguageOptionItem({
    super.key,
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CountryFlag.fromLanguageCode(
                option.code,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 16),
              Text(
                option.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Radio<bool>(
                value: true,
                groupValue: option.isSelected,
                onChanged: (_) => onTap(),
                activeColor: AppColors.secondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

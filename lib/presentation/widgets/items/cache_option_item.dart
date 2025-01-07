import 'package:envirosense/presentation/widgets/models/cache_option.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class CacheOptionItem extends StatelessWidget {
  final CacheOption option;
  final VoidCallback onTap;

  const CacheOptionItem({
    super.key,
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: option.isSelected ? AppColors.secondaryColor : AppColors.whiteColor,
            border: Border.all(
              color: option.isSelected ? AppColors.secondaryColor : AppColors.accentColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        color: option.isSelected ? AppColors.whiteColor : AppColors.secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.subtitle,
                      style: TextStyle(
                        color: option.isSelected ? AppColors.whiteColor.withOpacity(0.8) : AppColors.accentColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (option.isSelected)
                const Icon(
                  Icons.check_rounded,
                  color: AppColors.whiteColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

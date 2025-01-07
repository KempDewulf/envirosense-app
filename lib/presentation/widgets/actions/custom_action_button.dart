import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class CustomActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final bool isDestructive;
  final bool isWarning;
  final bool isNeutral;

  const CustomActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
    this.isDestructive = false,
    this.isWarning = false,
    this.isNeutral = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: isDestructive
            ? AppColors.redColor.withOpacity(0.4)
            : isWarning
                ? AppColors.secondaryColor.withOpacity(0.4)
                : isNeutral
                    ? AppColors.accentColor.withOpacity(0.4)
                    : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDestructive
                        ? const Color.fromARGB(255, 255, 0, 0)
                        : isWarning
                            ? AppColors.secondaryColor
                            : AppColors.blackColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDestructive
                      ? AppColors.redColor
                      : isWarning
                          ? AppColors.secondaryColor
                          : AppColors.blackColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

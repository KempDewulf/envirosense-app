import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/dialogs/custom_bottom_sheet_actions.dart';
import 'package:envirosense/presentation/widgets/dialogs/custom_bottom_sheet_header.dart';
import 'package:flutter/material.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String highlightedText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.highlightedText,
    required this.onConfirm,
    this.isDestructive = true,
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
          CustomBottomSheetHeader(title: title),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.blackColor,
                ),
                children: [
                  TextSpan(text: message),
                  TextSpan(
                    text: highlightedText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  const TextSpan(text: ' from this building?'),
                ],
              ),
            ),
          ),
          Divider(color: AppColors.accentColor.withOpacity(0.2)),
          CustomBottomSheetActions(
            onCancel: () => Navigator.pop(context),
            onSave: onConfirm,
            saveButtonText: 'Remove',
            isDestructive: isDestructive,
          ),
        ],
      ),
    );
  }
}

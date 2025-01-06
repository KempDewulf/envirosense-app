import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class CustomBottomSheetActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isDestructive;
  final String saveButtonText;

  const CustomBottomSheetActions({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.isDestructive = false,
    this.saveButtonText = 'Save',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.secondaryColor),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.secondaryColor),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: onSave,
                style: FilledButton.styleFrom(
                  backgroundColor: isDestructive ? AppColors.redColor : AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(saveButtonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

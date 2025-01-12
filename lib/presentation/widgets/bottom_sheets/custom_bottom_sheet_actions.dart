import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomSheetActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isDestructive;
  final String saveButtonText;

  const CustomBottomSheetActions({
    super.key,
    required this.onCancel,
    required this.onSave,
    required this.saveButtonText,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                child: Text(
                  l10n.cancel,
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

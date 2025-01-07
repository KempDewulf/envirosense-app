import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class DialogFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DialogFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }
}

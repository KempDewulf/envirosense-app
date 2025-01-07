import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class DialogOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DialogOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.secondaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.secondaryColor),
      ),
    );
  }
}

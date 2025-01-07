import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  const BaseDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(color: AppColors.accentColor),
      ),
      content: Text(
        content,
        style: const TextStyle(color: AppColors.accentColor),
      ),
      actions: actions,
    );
  }
}

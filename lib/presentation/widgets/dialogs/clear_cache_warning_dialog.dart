import 'package:envirosense/presentation/widgets/actions/dialog_filled_button.dart';
import 'package:envirosense/presentation/widgets/actions/dialog_outlined_button.dart';
import 'package:flutter/material.dart';
import 'base_dialog.dart';

class ClearCacheWarningDialog extends StatelessWidget {
  const ClearCacheWarningDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => const ClearCacheWarningDialog(),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Clear Cache',
      content:
          'This action will clear all cached data and log you out. Your account will remain intact but you will need to log in again.\n\nAre you sure you want to proceed?',
      actions: [
        DialogOutlinedButton(
          text: 'Cancel',
          onPressed: () => Navigator.pop(context, false),
        ),
        DialogFilledButton(
          text: 'Clear All',
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}

import 'package:envirosense/presentation/widgets/actions/dialog_filled_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return BaseDialog(
      title: l10n.clearCache,
      content: l10n.clearCacheMessage,
      actions: [
        DialogOutlinedButton(
          text: l10n.cancel,
          onPressed: () => Navigator.pop(context, false),
        ),
        DialogFilledButton(
          text: l10n.clearAll,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}

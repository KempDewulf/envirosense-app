import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SearchableType {
  room,
  device;

  String getTranslation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case SearchableType.room:
        return l10n.room.toLowerCase();
      case SearchableType.device:
        return l10n.device.toLowerCase();
    }
  }
}

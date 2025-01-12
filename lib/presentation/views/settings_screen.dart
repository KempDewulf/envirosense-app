import 'dart:io';

import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/data/models/language_model.dart';
import 'package:envirosense/main.dart';
import 'package:envirosense/services/language_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/presentation/widgets/bottom_sheets/clear_cache_options_sheet.dart';
import 'package:envirosense/presentation/widgets/dialogs/forgot_your_password_dialog.dart';
import 'package:envirosense/presentation/widgets/dialogs/sign_out_dialog.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _useImperialUnits = false;
  bool _isToggling = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useImperialUnits = prefs.getBool('useImperialUnits') ?? false;
    });
  }

  Future<void> _toggleUnits(bool value) async {
    final l10n = AppLocalizations.of(context)!;
    if (_isToggling) return;

    setState(() {
      _isToggling = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useImperialUnits', value);
    setState(() {
      _useImperialUnits = value;
    });

    if (!mounted) return;

    CustomSnackbar.showSnackBar(context, l10n.unitsChanged(value ? 'imperial' : 'metric'));

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isToggling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final supportedLanguages = [
      Language('en', l10n.english),
      Language('nl', l10n.dutch),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 70,
        foregroundColor: AppColors.whiteColor,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader(title: l10n.account),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ForgotPasswordDialog(),
                ),
                child: ListTile(
                  leading: Icon(Icons.lock_reset, color: AppColors.whiteColor),
                  title: Text(
                    l10n.forgotPasswordPrompt,
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => showDialog(context: context, builder: (context) => SignOutDialog()),
                child: ListTile(
                  leading: Icon(Icons.logout, color: AppColors.whiteColor),
                  title: Text(
                    l10n.signOut,
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          _SectionHeader(title: l10n.preferences),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              child: SwitchListTile(
                title: Text(
                  _useImperialUnits ? l10n.imperialUnits : l10n.metricUnits,
                  style: const TextStyle(color: AppColors.whiteColor),
                ),
                subtitle: Text(
                  _useImperialUnits ? l10n.usingFahrenheit : l10n.usingCelsius,
                  style: const TextStyle(
                    color: AppColors.lightGrayColor,
                  ),
                ),
                value: _useImperialUnits,
                activeColor: AppColors.whiteColor,
                activeTrackColor: AppColors.whiteColor.withOpacity(0.3),
                inactiveThumbColor: AppColors.whiteColor,
                inactiveTrackColor: AppColors.whiteColor.withOpacity(0.3),
                secondary: const Icon(
                  Icons.thermostat,
                  color: AppColors.whiteColor,
                ),
                onChanged: (value) {
                  _toggleUnits(value);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              l10n.selectLanguage,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...supportedLanguages.map(
                            (lang) => RadioListTile<String>(
                              title: Text(lang.name),
                              value: lang.code,
                              groupValue: LanguageService.instance.locale.languageCode,
                              onChanged: (_) async {
                                await LanguageService.instance.changeLocale(
                                  locale: Locale(lang.code),
                                );
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.language, color: AppColors.whiteColor),
                  title: Text(
                    l10n.language,
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.whiteColor,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          _SectionHeader(title: l10n.data),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => ClearCacheOptionsSheet.show(context),
                child: ListTile(
                  leading: Icon(Icons.cleaning_services, color: AppColors.whiteColor),
                  title: Text(
                    l10n.clearCache,
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.whiteColor,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.accentColor),
      ),
    );
  }
}

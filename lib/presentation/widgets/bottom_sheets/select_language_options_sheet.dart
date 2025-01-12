import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/items/language_option_item.dart';
import 'package:envirosense/presentation/widgets/models/language_option.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/services/language_service.dart';
import 'package:flutter/material.dart';

class SelectLanguageOptionsSheet extends StatefulWidget {
  const SelectLanguageOptionsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => SelectLanguageOptionsSheet(),
    );
  }

  @override
  State<SelectLanguageOptionsSheet> createState() => _SelectLanguageOptionsSheetState();
}

class _SelectLanguageOptionsSheetState extends State<SelectLanguageOptionsSheet> {
  late final List<LanguageOption> languageOptions;

  @override
  void initState() {
    super.initState();
    languageOptions = LanguageService.supportedLanguages
        .map((lang) => LanguageOption(
              code: lang.code,
              name: lang.name,
              isSelected: lang.code == LanguageService.instance.locale.languageCode,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectLanguage,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.selectLanguagePrompt,
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ...languageOptions.map(
                  (option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: LanguageOptionItem(
                      code: option.code,
                      name: option.name,
                      isSelected: option.isSelected,
                      onTap: () => _handleLanguageSelection(option),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.accentColor.withOpacity(0.2)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                      onPressed: () => _handleSave(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.save,
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLanguageSelection(LanguageOption selected) {
    setState(() {
      for (var option in languageOptions) {
        option.isSelected = option == selected;
      }
    });
  }

  void _handleSave() async {
    final selected = languageOptions.firstWhere((option) => option.isSelected);
    await LanguageService.instance.changeLocale(locale: Locale(selected.code));
    if (!mounted) return;
    Navigator.pop(context);
  }
}

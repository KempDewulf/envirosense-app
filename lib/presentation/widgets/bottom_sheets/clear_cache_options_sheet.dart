import 'package:envirosense/presentation/widgets/dialogs/clear_cache_warning_dialog.dart';
import 'package:envirosense/presentation/widgets/models/cache_option.dart';
import 'package:envirosense/services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/services/database_service.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../items/cache_option_item.dart';

class ClearCacheOptionsSheet extends StatefulWidget {
  const ClearCacheOptionsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => const ClearCacheOptionsSheet(),
    );
  }

  @override
  State<ClearCacheOptionsSheet> createState() => _ClearCacheOptionsSheetState();
}

class _ClearCacheOptionsSheetState extends State<ClearCacheOptionsSheet> {
  late List<CacheOption> cacheOptions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      cacheOptions = [
        CacheOption(
          title: l10n.deviceData,
          subtitle: l10n.clearSensorReadings,
        ),
        CacheOption(
          title: l10n.deviceNames,
          subtitle: l10n.resetDeviceNames,
        ),
        CacheOption(
          title: l10n.all,
          subtitle: l10n.clearAllData,
          isHighImpact: true,
        ),
      ];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    bool isSelected = cacheOptions.any((option) => option.isSelected);

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
                  l10n.clearCache,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.selectCachePrompt,
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ...cacheOptions.map(
                  (option) => CacheOptionItem(
                    option: option,
                    onTap: () => _handleOptionSelection(option),
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
                      onPressed: isSelected ? _handleClearCache : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.secondaryColor : AppColors.secondaryColor.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.clearCache,
                        style: TextStyle(
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

  void _handleOptionSelection(CacheOption option) {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      if (option.title == l10n.all) {
        // When "All" is selected/deselected, update all other options
        bool newValue = !option.isSelected;
        for (var opt in cacheOptions) {
          opt.isSelected = newValue;
        }
      } else {
        option.isSelected = !option.isSelected;
        // If all individual options are selected, select "All" as well
        CacheOption allOption = cacheOptions.firstWhere((opt) => opt.title == l10n.all);
        if (cacheOptions.where((opt) => opt.title != l10n.all).every((opt) => opt.isSelected)) {
          allOption.isSelected = true;
        } else {
          allOption.isSelected = false;
        }
      }
    });
  }

  void _handleClearCache() async {
    final l10n = AppLocalizations.of(context)!;
    if (!cacheOptions.any((option) => option.isSelected)) return;

    final DatabaseService dbService = DatabaseService();
    final AuthService authService = AuthService();

    final hasHighImpactSelection = cacheOptions.where((opt) => opt.isSelected).any((opt) => opt.isHighImpact);

    if (hasHighImpactSelection) {
      final confirmed = await ClearCacheWarningDialog.show(context);
      if (!confirmed) return;
    }

    if (!mounted) return;
    Navigator.pop(context);

    for (final option in cacheOptions) {
      if (option.isSelected) {
        if (option.title == l10n.deviceData) {
          await dbService.clearDeviceDataCache();
        } else if (option.title == l10n.deviceNames) {
          await dbService.clearDeviceNames();
        } else if (option.title == l10n.all) {
          await dbService.clearAll();
          await authService.signOut(context);
        }
      }
    }
  }
}

import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/core/custom_app_bar.dart';
import 'package:envirosense/presentation/widgets/dialogs/custom_bottom_sheet_header.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> _tabs = const [];

  bool _useImperialUnits = false;

  Future<void> _toggleUnits(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useImperialUnits', value);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 70,
        foregroundColor: AppColors.whiteColor,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const _SectionHeader(title: 'Account'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => UnimplementedError,
                child: ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.whiteColor),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          const _SectionHeader(title: 'Preferences'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              child: SwitchListTile(
                title: Text(
                  _useImperialUnits ? 'Imperial Units' : 'Metric Units',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                subtitle: Text(
                  _useImperialUnits ? 'Using Fahrenheit' : 'Using Celsius',
                  style: TextStyle(
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
                  setState(() {
                    _useImperialUnits = value;
                  });
                  _toggleUnits;
                },
              ),
            ),
          ),
          const _SectionHeader(title: 'Data'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showClearCacheOptions(context),
                child: ListTile(
                  leading: const Icon(
                    Icons.cleaning_services,
                    color: AppColors.whiteColor,
                  ),
                  title: const Text(
                    'Clear Cache',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                  trailing: const Icon(
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

  Future<void> _showClearCacheOptions(BuildContext context) async {
    final List<CacheOption> cacheOptions = [
      CacheOption(
        title: 'Device Data Cache',
        subtitle: 'Clear stored sensor readings and statistics',
      ),
      CacheOption(
        title: 'Device Names Cache',
        subtitle: 'Reset custom device names to defaults',
      ),
      CacheOption(
        title: 'All Cache',
        subtitle: 'Clear all stored data and preferences',
      ),
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                    const Text(
                      'Clear Cache',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select the data you want to remove',
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...cacheOptions.map((option) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.accentColor.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              option.title,
                              style: const TextStyle(
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              option.subtitle,
                              style: TextStyle(
                                color: AppColors.accentColor,
                                fontSize: 14,
                              ),
                            ),
                            value: option.isSelected,
                            onChanged: (value) {
                              setState(() => option.isSelected = value ?? false);
                            },
                            activeColor: AppColors.secondaryColor,
                            checkColor: AppColors.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )),
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
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.secondaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: cacheOptions.any((option) => option.isSelected)
                              ? () async {
                                  Navigator.pop(context);
                                  // ... existing cache clearing logic ...
                                  if (!context.mounted) return;
                                  CustomSnackbar.showSnackBar(context, 'Selected cache cleared');
                                }
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Clear Selected',
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
      ),
    );
  }
}

class CacheOption {
  final String title;
  final String subtitle;
  bool isSelected;

  CacheOption({
    required this.title,
    required this.subtitle,
    this.isSelected = false,
  });
}

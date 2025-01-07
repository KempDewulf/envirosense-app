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
        title: 'Device Data',
        subtitle: 'Clear stored sensor readings',
        isHighImpact: false,
      ),
      CacheOption(
        title: 'Device Names',
        subtitle: 'Reset device names to default',
        isHighImpact: false,
      ),
      CacheOption(
        title: 'All',
        subtitle: 'Clear all stored data and preferences',
        isHighImpact: true,
      ),
    ];

    Future<bool> showClearAllWarning(BuildContext context) async {
      return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              backgroundColor: AppColors.whiteColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: const Text(
                'Warning',
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                'This action will clear all cached data and log you out. Your account will remain intact but you will need to log in again.\n\nAre you sure you want to proceed?',
                style: TextStyle(color: AppColors.accentColor),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.secondaryColor),
                  ),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ) ??
          false;
    }

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
                      'Select the cache you want to remove',
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...cacheOptions.map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => setState(() => option.isSelected = !option.isSelected),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: option.isSelected ? AppColors.secondaryColor : AppColors.whiteColor,
                                border: Border.all(
                                  color: option.isSelected ? AppColors.secondaryColor : AppColors.accentColor.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option.title,
                                          style: TextStyle(
                                            color: option.isSelected ? AppColors.whiteColor : AppColors.secondaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          option.subtitle,
                                          style: TextStyle(
                                            color: option.isSelected ? AppColors.whiteColor.withOpacity(0.8) : AppColors.accentColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (option.isSelected)
                                    const Icon(
                                      Icons.check_rounded,
                                      color: AppColors.whiteColor,
                                      size: 24,
                                    ),
                                ],
                              ),
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
                                  //add logic here
                                  final hasHighImpactSelection = cacheOptions.where((opt) => opt.isSelected).any((opt) => opt.isHighImpact);

                                  if (hasHighImpactSelection) {
                                    final confirmed = await showClearAllWarning(context);
                                    if (!confirmed) return;
                                  }
                                  Navigator.pop(context);

                                  for (final option in cacheOptions) {
                                    if (option.isSelected && option.isHighImpact) {
                                      //logout and logic
                                    } else {
                                      // Handle regular cache clearing
                                    }
                                  }

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
  final bool isHighImpact;

  CacheOption({
    required this.title,
    required this.subtitle,
    this.isSelected = false,
    this.isHighImpact = false,
  });
}

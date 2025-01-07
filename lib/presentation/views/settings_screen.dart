import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/core/custom_app_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> _tabs = const [];

  bool _useImperialUnits = false;

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
                title: const Text(
                  'Imperial Units',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                subtitle: const Text(
                  'Use Fahrenheit instead of Celsius',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                value: _useImperialUnits,
                activeColor: AppColors.accentColor,
                secondary: const Icon(
                  Icons.thermostat,
                  color: AppColors.whiteColor,
                ),
                onChanged: (value) => UnimplementedError,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Clear Cache',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...cacheOptions.map((option) => CheckboxListTile(
                    title: Text(option.title),
                    subtitle: Text(option.subtitle),
                    value: option.isSelected,
                    onChanged: (value) {
                      setState(() => option.isSelected = value ?? false);
                    },
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: cacheOptions.any((option) => option.isSelected)
                    ? () async {
                        Navigator.pop(context);
                        // Clear selected caches
                        if (cacheOptions[0].isSelected) {
                          UnimplementedError();
                        }
                        if (cacheOptions[1].isSelected) {
                          UnimplementedError();
                        }
                        if (cacheOptions[2].isSelected) {
                          UnimplementedError();
                        }
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selected caches cleared')),
                        );
                      }
                    : null,
                child: const Text('Clear Selected'),
              ),
              const SizedBox(height: 8),
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

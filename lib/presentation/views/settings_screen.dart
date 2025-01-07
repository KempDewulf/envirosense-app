import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/bottom_sheets/clear_cache_options_sheet.dart';
import 'package:envirosense/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _useImperialUnits = false;
  final AuthService _authService = AuthService();

  Future<void> _toggleUnits(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useImperialUnits', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
                onTap: () => _authService.signOut(context),
                child: const ListTile(
                  leading: Icon(Icons.logout, color: AppColors.whiteColor),
                  title: Text(
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
                  style: const TextStyle(color: AppColors.whiteColor),
                ),
                subtitle: Text(
                  _useImperialUnits ? 'Using Fahrenheit' : 'Using Celsius',
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
                onTap: () => ClearCacheOptionsSheet.show(context),
                child: const ListTile(
                  leading: Icon(Icons.cleaning_services, color: AppColors.whiteColor),
                  title: Text(
                    'Clear Cache',
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

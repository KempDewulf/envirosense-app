import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';

enum DisplayMode { default_view, temperature, humidity, ppm }

class DeviceControlsTab extends StatefulWidget {
  const DeviceControlsTab({super.key});

  @override
  State<DeviceControlsTab> createState() => _DeviceControlsTabState();
}

class _DeviceControlsTabState extends State<DeviceControlsTab> {
  DisplayMode _selectedMode = DisplayMode.default_view;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Display Mode',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildModeCard(
                  DisplayMode.default_view,
                  'Default View',
                  Icons.dashboard_outlined,
                ),
                _buildModeCard(
                  DisplayMode.temperature,
                  'Temperature',
                  Icons.thermostat_outlined,
                ),
                _buildModeCard(
                  DisplayMode.humidity,
                  'Humidity',
                  Icons.water_drop_outlined,
                ),
                _buildModeCard(
                  DisplayMode.ppm,
                  'CO2 PPM',
                  Icons.air_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard(DisplayMode mode, String title, IconData icon) {
    final isSelected = _selectedMode == mode;
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: () => setState(() => _selectedMode = mode),
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryColor : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.secondaryColor : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: isSelected ? AppColors.whiteColor : Colors.grey[600],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.whiteColor : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

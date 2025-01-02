import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/tabs/device_controls_tab.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DisplayModeSelector extends StatelessWidget {
  DisplayMode selectedMode;
  final Function(DisplayMode) onModeSelected;

  DisplayModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.screen_rotation, color: AppColors.secondaryColor),
            const SizedBox(width: 8),
            const Text(
              'Screen Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 170,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildModeCard(DisplayMode.defaultView, 'Default View',
                  Icons.dashboard_outlined),
              _buildModeCard(DisplayMode.temperature, 'Temperature',
                  Icons.thermostat_outlined),
              _buildModeCard(
                  DisplayMode.humidity, 'Humidity', Icons.water_drop_outlined),
              _buildModeCard(DisplayMode.ppm, 'CO2 PPM', Icons.air_outlined),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModeCard(DisplayMode mode, String title, IconData icon) {
    final isSelected = selectedMode == mode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () => onModeSelected(mode),
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.secondaryColor
                : AppColors.lightGrayColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondaryColor
                  : AppColors.lightGrayColor,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color:
                    isSelected ? AppColors.whiteColor : AppColors.accentColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected ? AppColors.whiteColor : AppColors.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

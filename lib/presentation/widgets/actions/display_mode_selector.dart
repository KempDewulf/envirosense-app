import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/core/enums/display_mode.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DisplayModeSelector extends StatelessWidget {
  DisplayMode selectedMode;
  final Function(DisplayMode) onModeSelected;
  final bool isLoading;
  final bool hasError;

  DisplayModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
    this.isLoading = false,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              hasError ? Icons.error_outline : Icons.screen_rotation,
              color: hasError ? AppColors.redColor : AppColors.secondaryColor,
            ),
            const SizedBox(width: 8),
            const Text(
              'Screen Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (hasError)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Failed to fetch display modes',
              style: TextStyle(
                color: AppColors.accentColor,
                fontSize: 18,
              ),
            ),
          )
        else if (isLoading)
          const Center(
            child: SizedBox(
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor)),
                  SizedBox(height: 16),
                  Text(
                    'Loading',
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          // Existing display mode selector UI
          SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildModeCard(DisplayMode.normal, 'Default View', Icons.dashboard_outlined),
                _buildModeCard(DisplayMode.temperature, 'Temperature', Icons.thermostat_outlined),
                _buildModeCard(DisplayMode.humidity, 'Humidity', Icons.water_drop_outlined),
                _buildModeCard(DisplayMode.ppm, 'CO2 Level', Icons.air_outlined),
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
            color: isSelected ? AppColors.secondaryColor : AppColors.lightGrayColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.secondaryColor : AppColors.lightGrayColor,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: isSelected ? AppColors.whiteColor : AppColors.accentColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.whiteColor : AppColors.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';

enum DisplayMode { defaultView, temperature, humidity, ppm }

class DeviceControlsTab extends StatefulWidget {
  const DeviceControlsTab({super.key});

  @override
  State<DeviceControlsTab> createState() => _DeviceControlsTabState();
}

class _DeviceControlsTabState extends State<DeviceControlsTab> {
  DisplayMode _selectedMode = DisplayMode.defaultView;
  int _brightnessLevel = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.screen_rotation,
                  color: AppColors.secondaryColor),
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
                _buildModeCard(
                  DisplayMode.defaultView,
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
          const SizedBox(height: 36),
          Row(
            children: [
              const Icon(Icons.brightness_6, color: AppColors.secondaryColor),
              const SizedBox(width: 8),
              const Text(
                'Brightness',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          _buildBrightnessControl(),
        ],
      ),
    );
  }

  Widget _buildBrightnessControl() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (_brightnessLevel > 0) {
              setState(() => _brightnessLevel--);
            }
          },
          icon: const Icon(Icons.remove_circle),
          color: AppColors.secondaryColor,
        ),
        Expanded(
          child: Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index < _brightnessLevel
                        ? AppColors.secondaryColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
        IconButton(
          onPressed: () {
            if (_brightnessLevel < 5) {
              setState(() => _brightnessLevel++);
            }
          },
          icon: const Icon(Icons.add_circle),
          color: AppColors.secondaryColor,
        ),
      ],
    );
  }

  Widget _buildModeCard(DisplayMode mode, String title, IconData icon) {
    final isSelected = _selectedMode == mode;
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: () => setState(() => _selectedMode = mode),
        child: Container(
          width: 130,
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

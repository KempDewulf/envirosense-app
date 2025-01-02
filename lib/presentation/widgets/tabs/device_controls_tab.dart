import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/actions/brightness_control.dart';
import 'package:envirosense/presentation/widgets/actions/display_mode_selector.dart';
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        DisplayModeSelector(
          selectedMode: _selectedMode,
          onModeSelected: (mode) => setState(() => _selectedMode = mode),
        ),
        const SizedBox(height: 36),
        BrightnessControl(
          level: _brightnessLevel,
          onChanged: (level) => setState(() => _brightnessLevel = level),
        ),
      ],
    );
  }

  Widget _buildBrightnessControl() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (_brightnessLevel > 1) {
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
}

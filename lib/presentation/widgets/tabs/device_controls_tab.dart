import 'package:envirosense/core/enums/display_mode.dart';
import 'package:envirosense/presentation/widgets/actions/brightness_control.dart';
import 'package:envirosense/presentation/widgets/actions/display_mode_selector.dart';
import 'package:flutter/material.dart';

class DeviceControlsTab extends StatefulWidget {
  const DeviceControlsTab({super.key});

  @override
  State<DeviceControlsTab> createState() => _DeviceControlsTabState();
}

class _DeviceControlsTabState extends State<DeviceControlsTab> {
  DisplayMode _selectedMode = DisplayMode.normal;
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
}

import 'package:envirosense/core/enums/display_mode.dart';
import 'package:envirosense/core/helpers/debouncer.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';
import 'package:envirosense/presentation/widgets/actions/brightness_control.dart';
import 'package:envirosense/presentation/widgets/actions/display_mode_selector.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:flutter/material.dart';

class DeviceControlsTab extends StatefulWidget {
  final String deviceId;
  final DeviceController deviceController;

  const DeviceControlsTab({
    super.key,
    required this.deviceId,
    required this.deviceController,
  });
  @override
  State<DeviceControlsTab> createState() => _DeviceControlsTabState();
}

class _DeviceControlsTabState extends State<DeviceControlsTab> {
  DisplayMode _selectedMode = DisplayMode.normal;
  int _brightnessValue = 3;
  final _uiModeDebouncer = Debouncer(delay: const Duration(milliseconds: 1500));
  final _brightnessDebouncer =
      Debouncer(delay: const Duration(milliseconds: 1500));

  Future<void> _updateDeviceUIMode(DisplayMode mode) async {
    _uiModeDebouncer.call(() async {
      try {
        await widget.deviceController.updateDeviceUIMode(widget.deviceId, mode);
        setState(() => _selectedMode = mode);
        if (mounted) {
          CustomSnackbar.showSnackBar(
              context, 'Display mode successfully updated to $mode');
        }
      } catch (e) {
        if (mounted) {
          CustomSnackbar.showSnackBar(context, 'Failed to update display mode');
        }
      }
    });
  }

  Future<void> _updateBrightnessLimit(int value) async {
    _brightnessDebouncer.call(() async {
      try {
        await widget.deviceController.updateDeviceBrightness(widget.deviceId, value);
        setState(() => _brightnessValue = value);
        if (mounted) {
          CustomSnackbar.showSnackBar(
              context, 'Brightness successfully updated to $value');
        }
      } catch (e) {
        if (mounted) {
          CustomSnackbar.showSnackBar(context, 'Failed to update brightness');
        }
      }
    });
  }

  @override
  void dispose() {
    _uiModeDebouncer.dispose();
    _brightnessDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        DisplayModeSelector(
          selectedMode: _selectedMode,
          onModeSelected: _updateDeviceUIMode,
        ),
        const SizedBox(height: 36),
        BrightnessControl(
          value: _brightnessValue,
          onChanged: _updateBrightnessLimit,
        ),
      ],
    );
  }
}

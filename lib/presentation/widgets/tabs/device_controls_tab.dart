import 'package:envirosense/core/enums/config_type.dart';
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
  int _brightnessValue = 80;

  Future<void> _updateDeviceConfig<T>({
    required ConfigType configType,
    required T value,
    required String successMessage,
    required Duration debounceDelay,
    required void Function(T) onSuccess,
  }) async {
    final debouncer = Debouncer(delay: debounceDelay);

    debouncer.call(() async {
      try {
        final apiValue = value is DisplayMode ? value.toApiString : value;

        await widget.deviceController.updateDeviceConfig(
          widget.deviceId,
          configType,
          apiValue,
        );

        if (mounted) {
          setState(() => onSuccess(value));
          CustomSnackbar.showSnackBar(context, successMessage);
        }
      } catch (e) {
        if (mounted) {
          CustomSnackbar.showSnackBar(context, 'Failed to update ${configType.name.toLowerCase()}');
        }
      }
    });
  }

  Future<void> _updateDeviceUIMode(DisplayMode mode) async {
    await _updateDeviceConfig<DisplayMode>(
      configType: ConfigType.uiMode,
      value: mode,
      successMessage: 'Display mode successfully updated to ${mode.name}',
      debounceDelay: const Duration(milliseconds: 1500),
      onSuccess: (value) => _selectedMode = value,
    );
  }

  Future<void> _updateBrightnessLimit(int value) async {
    await _updateDeviceConfig<int>(
      configType: ConfigType.brightness,
      value: value,
      successMessage: 'Brightness successfully updated to $value',
      debounceDelay: const Duration(milliseconds: 1500),
      onSuccess: (value) => _brightnessValue = value,
    );
  }

  @override
  void dispose() {
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

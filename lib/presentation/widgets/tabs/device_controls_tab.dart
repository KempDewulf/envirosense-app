import 'package:envirosense/core/enums/config_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/core/enums/display_mode.dart';
import 'package:envirosense/core/helpers/debouncer.dart';
import 'package:envirosense/domain/entities/device_config.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';
import 'package:envirosense/presentation/widgets/actions/brightness_control.dart';
import 'package:envirosense/presentation/widgets/actions/display_mode_selector.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:flutter/material.dart';

class DeviceControlsTab extends StatefulWidget {
  final String deviceId;
  final DeviceController deviceController;
  final DeviceConfig? deviceConfig;
  final Map<String, bool> loadingConfig;

  const DeviceControlsTab({
    super.key,
    required this.deviceId,
    required this.deviceController,
    this.deviceConfig,
    required this.loadingConfig,
  });
  @override
  State<DeviceControlsTab> createState() => _DeviceControlsTabState();
}

class _DeviceControlsTabState extends State<DeviceControlsTab> {
  late DisplayMode _selectedMode;
  late int _brightnessValue;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  @override
  void didUpdateWidget(DeviceControlsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deviceConfig != widget.deviceConfig) {
      _initializeValues();
    }
  }

  void _initializeValues() {
    _selectedMode = widget.deviceConfig?.uiMode != null ? DisplayModeExtension.fromString(widget.deviceConfig!.uiMode) : DisplayMode.normal;
    _brightnessValue = widget.deviceConfig?.brightness ?? 80;
  }

  Future<void> _updateDeviceConfig<T>({
    required ConfigType configType,
    required T value,
    required String successMessage,
    required Duration debounceDelay,
    required void Function(T) onSuccess,
  }) async {
    final l10n = AppLocalizations.of(context)!;
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
          CustomSnackbar.showSnackBar(context, l10n.configUpdateError(configType.name.toLowerCase()));
        }
      }
    });
  }

  Future<void> _updateDeviceUIMode(DisplayMode mode) async {
    final l10n = AppLocalizations.of(context)!;
    await _updateDeviceConfig<DisplayMode>(
      configType: ConfigType.uiMode,
      value: mode,
      successMessage: l10n.displayModeUpdateSuccess(mode.toDisplayString),
      debounceDelay: const Duration(milliseconds: 1500),
      onSuccess: (value) => _selectedMode = value,
    );
  }

  Future<void> _updateBrightnessLimit(int value) async {
    final l10n = AppLocalizations.of(context)!;

    await _updateDeviceConfig<int>(
      configType: ConfigType.brightness,
      value: value,
      successMessage: l10n.brightnessUpdateSuccess(value),
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
    final bool hasError = widget.deviceConfig?.failed ?? false;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        DisplayModeSelector(
          selectedMode: _selectedMode,
          onModeSelected: _updateDeviceUIMode,
          isLoading: widget.loadingConfig['ui-mode'] ?? false,
          hasError: hasError,
        ),
        const SizedBox(height: 36),
        BrightnessControl(
          value: _brightnessValue,
          onChanged: _updateBrightnessLimit,
          isLoading: widget.loadingConfig['brightness'] ?? false,
          hasError: hasError,
        ),
      ],
    );
  }
}

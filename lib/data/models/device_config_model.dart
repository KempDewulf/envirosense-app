import 'package:envirosense/domain/entities/device_config.dart';

class DeviceConfigModel extends DeviceConfig {
  DeviceConfigModel({
    required super.id,
    required super.config,
    super.failed = false,
  });

  factory DeviceConfigModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      return DeviceConfigModel(
        id: '',
        config: {},
        failed: true,
      );
    }

    final configMap = json['config'] as Map<String, dynamic>;
    if (configMap.containsKey('brightness')) {
      final brightness = configMap['brightness'];
      if (brightness is String) {
        configMap['brightness'] = int.parse(brightness);
      }
    }

    return DeviceConfigModel(
      id: json['documentId'] as String,
      config: configMap,
      failed: json['failed'] as bool? ?? false,
    );
  }
}

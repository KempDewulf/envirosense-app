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

    return DeviceConfigModel(
      id: json['documentId'] as String,
      config: Map<String, dynamic>.from(json['config'] as Map),
      failed: json['failed'] as bool,
    );
  }
}

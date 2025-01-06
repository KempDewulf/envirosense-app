class DeviceConfig {
  final String id;
  final Map<String, dynamic> config;
  final bool failed;

  const DeviceConfig({
    required this.id,
    required this.config,
    this.failed = false,
  });

  dynamic get uiMode => config['ui-mode'];
  int? get brightness => config['brightness'];

  factory DeviceConfig.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      return DeviceConfig(
        id: '',
        config: {},
        failed: true,
      );
    }

    return DeviceConfig(
      id: json['documentId'] as String,
      config: Map<String, dynamic>.from(json['config'] as Map),
      failed: json['failed'] as bool,
    );
  }
}

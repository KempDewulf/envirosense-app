enum ConfigType {
  brightness,
  uiMode,
}

extension ConfigTypeExtension on ConfigType {
  String get toApiString {
    switch (this) {
      case ConfigType.uiMode:
        return 'ui-mode';
      case ConfigType.brightness:
        return 'brightness';
      default:
        return name;
    }
  }
}

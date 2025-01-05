enum LimitType {
  temperature,
  humidity,
  co2,
  light;
}

extension LimitTypeExtension on LimitType {
  String get toApiString {
    switch (this) {
      case LimitType.temperature:
        return 'temperature';
      case LimitType.humidity:
        return 'humidity';
      case LimitType.co2:
        return 'co2';
      case LimitType.light:
        return 'light';
    }
  }
}

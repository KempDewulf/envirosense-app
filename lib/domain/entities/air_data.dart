class AirData {
  final double? temperature;
  final double? humidity;
  final int? gasPpm;

  AirData({
    required this.temperature,
    required this.humidity,
    required this.gasPpm,
  });

  @override
  String toString() {
    return 'AirData{temperature: $temperature, humidity: $humidity, gasPpm: $gasPpm}';
  }
}

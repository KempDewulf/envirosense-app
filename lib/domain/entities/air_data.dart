class AirData {
  final double? temperature;
  final double? humidity;
  final int? ppm;

  AirData({
    required this.temperature,
    required this.humidity,
    required this.ppm,
  });

  @override
  String toString() {
    return 'AirData{temperature: $temperature, humidity: $humidity, ppm: $ppm}';
  }
}

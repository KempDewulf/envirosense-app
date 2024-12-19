import 'package:envirosense/domain/entities/device.dart';

class AirData {
  final String temperature;
  final Device humidity;
  final String gasPpm;

  AirData({
    required this.temperature,
    required this.humidity,
    required this.gasPpm,
  });
}

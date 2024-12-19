import 'package:envirosense/domain/entities/device.dart';

class AirData {
  final String id;
  final Device device;
  final String timestamp;
  final AirData airData;

  AirData({
    required this.id,
    required this.device,
    required this.timestamp,
    required this.airData,
  });
}

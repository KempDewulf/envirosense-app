import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/entities/device.dart';

class DeviceData {
  final String id;
  final Device device;
  final String timestamp;
  final AirData airData;

  DeviceData({
    required this.id,
    required this.device,
    required this.timestamp,
    required this.airData,
  });
}

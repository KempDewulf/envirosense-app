import 'package:envirosense/domain/entities/device_data.dart';
import 'package:envirosense/domain/entities/room.dart';

class Device {
  final String id;
  final String identifier;
  final Room room;
  final List<DeviceData>? deviceData;

  Device({
    required this.id,
    required this.identifier,
    required this.room,
    required this.deviceData,
  });
}

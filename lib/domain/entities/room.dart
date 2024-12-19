import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/domain/entities/roomtype.dart';

class Room {
  final String id;
  final String name;
  final Building building;
  final RoomType roomType;
  final List<Device>? devices;

  Room({
    required this.id,
    required this.name,
    required this.building,
    required this.roomType,
    required this.devices,
  });
}

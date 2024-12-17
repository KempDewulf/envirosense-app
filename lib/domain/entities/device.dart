import 'package:envirosense/domain/entities/room.dart';

class Device {
  final String id;
  final String name;
  final Room room;

  Device({
    required this.id,
    required this.name,
    required this.room,
  });
}
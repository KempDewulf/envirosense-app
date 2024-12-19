import 'package:envirosense/domain/entities/room.dart';

class RoomType {
  final String id;
  final String name;
  final String icon;
  final List<Room>? rooms;

  RoomType({
    required this.id,
    required this.name,
    required this.icon,
    this.rooms,
  });
}

import 'package:envirosense/domain/entities/room.dart';

class Building {
  final String id;
  final String name;
  final String address;
  final List<Room>? rooms;

  Building({
    required this.id,
    required this.name,
    required this.address,
    this.rooms,
  });
}

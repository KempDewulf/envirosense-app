import '../../domain/entities/room.dart';

class RoomModel extends Room {
  RoomModel({
    required super.id,
    required super.name,
    required super.building,
    required super.roomType,
    required super.devices,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['documentId'],
      name: json['name'],
      building: json['building'],
      roomType: json['roomType'],
      devices: json['devices'],
    );
  }
}

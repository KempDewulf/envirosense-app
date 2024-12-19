import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/entities/roomtype.dart';

class RoomTypeModel extends RoomType {
  RoomTypeModel({
    required super.id,
    required super.name,
    required super.icon,
    super.rooms,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json, String buildingId) {
    List<Room> rooms = (json['rooms'] as List)
        .map((roomJson) => Room(id: roomJson['rooms']['documentId'], name: roomJson['rooms']['name'], roomType: RoomType(id: json['documentId'], name: json['name'], icon: json['name'].toString().toLowerCase()), building: Building(id: buildingId, name: "Campus Brugge Station - Building A", address: "Spoorwegstraat 4, 8200 Brugge")))
        .toList();

    return RoomTypeModel(
      id: json['documentId'],
      name: json['name'],
      icon: json['icon'],
      rooms: rooms,
    );
  }
}

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
    List<Room> rooms = [];
    if (json['rooms'] != null) {
      rooms = (json['rooms'] as List<dynamic>).map((roomJson) {
        return Room(
          id: roomJson['documentId'],
          name: roomJson['name'],
          roomType: RoomType(
            id: json['documentId'],
            name: json['name'],
            icon: json['name'].toString().toLowerCase(),
          ),
          building: Building(
            id: buildingId,
            name: 'Campus Brugge Station - Building A',
            address: 'Spoorwegstraat 4, 8200 Brugge',
          ),
        );
      }).toList();
    }

    return RoomTypeModel(
      id: json['documentId'],
      name: json['name'],
      icon: json['name'].toString().toLowerCase(),
      rooms: rooms,
    );
  }
}

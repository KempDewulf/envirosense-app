import 'package:envirosense/domain/entities/roomtype.dart';

class RoomTypeModel extends RoomType {
  RoomTypeModel({
    required super.id,
    required super.name,
    required super.icon,
    super.rooms,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    return RoomTypeModel(
      id: json['documentId'],
      name: json['name'],
      icon: json['icon'],
      rooms: json['rooms'],
    );
  }
}

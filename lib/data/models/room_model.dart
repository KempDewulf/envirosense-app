import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/domain/entities/roomtype.dart';

import '../../domain/entities/room.dart';

class RoomModel extends Room {
  RoomModel({
    required super.id,
    required super.name,
    required super.building,
    required super.roomType,
    super.devices,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    Building building = Building(
      id: json['building']['documentId'],
      name: json['building']['name'],
      address: json['building']['address'],
    );

    RoomType roomType = RoomType(
      id: json['roomType']['documentId'],
      name: json['roomType']['name'],
      icon: json['roomType']['name'].toString().toLowerCase(),
    );

    List<Device> devices = (json['devices'] as List)
        .map((deviceJson) => Device(
            id: deviceJson['documentId'], identifier: deviceJson['identifier']))
        .toList();

    return RoomModel(
      id: json['documentId'],
      name: json['name'],
      building: building,
      roomType: roomType,
      devices: devices,
    );
  }
}

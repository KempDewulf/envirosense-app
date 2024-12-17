import 'package:flutter/material.dart';
import '../../domain/entities/room.dart';

class RoomModel extends Room {
  RoomModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.devices,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    // Get room type to determine icon
    final roomType = json['room-type'] as Map<String, dynamic>;
    final devices = json['devices'] as List<dynamic>;
    return RoomModel(
      id: json['documentId'] as String,
      name: json['name'] as String,
      icon: _getIconForRoomType(roomType['name'] as String),
      devices: devices.length,
    );
  }

  static IconData _getIconForRoomType(String roomType) {
    final Map<String, IconData> iconMap = {
      'cafeteria': Icons.coffee,
      'bedroom': Icons.bed,
      'bathroom': Icons.bathtub,
      'office': Icons.work,
      'tv room': Icons.tv,
      'classroom': Icons.class_,
      'garage': Icons.garage,
      'toilet': Icons.family_restroom,
      'kid room': Icons.child_friendly,
    };

    return iconMap[roomType.toLowerCase()] ?? Icons.room;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'room-type': {
        'name': _getRoomTypeFromIcon(icon),
      },
    };
  }

  static String _getRoomTypeFromIcon(IconData icon) {
    final Map<IconData, String> reverseIconMap = {
      Icons.coffee: 'Cafeteria',
      Icons.bed: 'Bedroom',
      Icons.bathtub: 'Bathroom',
      Icons.work: 'Office',
      Icons.tv: 'TV Room',
      Icons.class_: 'Classroom',
      Icons.garage: 'Garage',
      Icons.family_restroom: 'Toilet',
      Icons.child_friendly: 'Kid Room',
    };

    return reverseIconMap[icon] ?? 'Room';
  }
}

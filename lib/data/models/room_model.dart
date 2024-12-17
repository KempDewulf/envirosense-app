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
    switch (roomType.toLowerCase()) {
      case 'classroom':
        return Icons.class_;
      case 'office':
        return Icons.work;
      case 'bathroom':
        return Icons.bathroom;
      // Add more cases as needed
      default:
        return Icons.room;
    }
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
    if (icon == Icons.class_) return 'Classroom';
    if (icon == Icons.work) return 'Office';
    if (icon == Icons.bathroom) return 'Bathroom';
    // Add more cases as needed
    return 'Room';
  }
}

import 'package:flutter/material.dart';
import '../../domain/entities/room.dart';

class RoomModel extends Room {
  RoomModel({
    required String id,
    required String name,
    required IconData icon,
    required int devices,
  }) : super(id: id, name: name, icon: icon, devices: devices);

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
      devices: json['devices'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': icon.codePoint,
      'devices': devices,
    };
  }
}

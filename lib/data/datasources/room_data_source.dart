import 'package:envirosense/domain/entities/room.dart';
import 'package:flutter/material.dart';

import '../models/room_model.dart';

class RoomDataSource {
  Future<List<RoomModel>> getRooms() async {
    return [
      RoomModel(
        id: '1',
        name: '3.108',
        icon: Icons.chair,
        devices: 1,
      ),
      RoomModel(
        id: '2',
        name: '3.109',
        icon: Icons.meeting_room,
        devices: 2,
      ),
      RoomModel(
        id: '3',
        name: '3.110',
        icon: Icons.computer,
        devices: 3,
      ),
      RoomModel(
        id: '4',
        name: '3.111',
        icon: Icons.laptop,
        devices: 4,
      ),
      RoomModel(
        id: '5',
        name: '3.112',
        icon: Icons.tv,
        devices: 0,
      ),
      RoomModel(
        id: '6',
        name: '3.113',
        icon: Icons.headphones,
        devices: 2,
      ),
    ];
  }

  Future<void> addRoom(Room room) async {
    //TODO: Implement API call here
  }

  Future<void> removeRoom(String roomName) async {
    //TODO: Implement API call here
  }
}

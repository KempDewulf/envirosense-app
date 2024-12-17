import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../models/room_model.dart';

class RoomDataSource {
  final ApiService apiService;

  RoomDataSource({required this.apiService});
  
  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await apiService.getRequest('rooms');
      print(response);
      List<dynamic> data = response as List<dynamic>;
      List<RoomModel> rooms = data.map((roomJson) {
        return RoomModel.fromJson(
          roomJson as Map<String, dynamic>,
      );
    }).toList();
      print(rooms);
      return rooms;
    } catch (e) {
      // Handle errors
      throw Exception('Failed to load rooms: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRoomTypes() async {
    return [
      {'name': 'Cafeteria', 'icon': Icons.coffee},
      {'name': 'Bedroom', 'icon': Icons.bed},
      {'name': 'Bathroom', 'icon': Icons.bathtub},
      {'name': 'Office', 'icon': Icons.work},
      {'name': 'TV Room', 'icon': Icons.tv},
      {'name': 'Classroom', 'icon': Icons.class_},
      {'name': 'Garage', 'icon': Icons.garage},
      {'name': 'Toilet', 'icon': Icons.family_restroom},
      {'name': 'Kid Room', 'icon': Icons.child_friendly},
    ];
  }

  Future<void> addRoom(RoomModel room) async {
    //TODO: Implement API call here
  }

  Future<void> removeRoom(String roomName) async {
    //TODO: Implement API call here
  }
}

import 'package:envirosense/data/models/add_device_to_room_request_model.dart';
import 'package:envirosense/data/models/add_room_request_model.dart';
import 'package:envirosense/data/models/air_quality_model.dart';
import 'package:envirosense/data/models/update_room_request_model.dart';

import '../../services/api_service.dart';
import '../models/room_model.dart';

class RoomDataSource {
  final ApiService apiService;

  RoomDataSource({required this.apiService});

  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await apiService.getRequest('rooms');

      List<dynamic> data = response.data as List<dynamic>;
      List<RoomModel> rooms = data.map((roomJson) {
        return RoomModel.fromJson(roomJson);
      }).toList();
      return rooms;
    } catch (e) {
      // Handle errors
      throw Exception('Failed to load rooms: $e');
    }
  }

  Future<RoomModel> getRoom(String roomId) async {
    try {
      final response = await apiService.getRequest('rooms/$roomId');

      return RoomModel.fromJson(response.data);
    } catch (e) {
      // Handle errors
      throw Exception('Failed to load room: $e');
    }
  }

  Future<AirQualityModel> getAirQuality(String roomId) async {
    try {
      final response = await apiService.getRequest('rooms/$roomId/air-quality');
      return AirQualityModel.fromJson(response.data);
    } catch (e) {
      // Handle errors
      throw Exception('Failed to load air quality: $e');
    }
  }

  Future<void> addRoom(
      String? name, String buildingId, String? roomTypeId) async {
    try {
      AddRoomRequest body = AddRoomRequest(name, buildingId, roomTypeId);

      await apiService.postRequest('rooms', body.toJson());
    } catch (e) {
      // Handle errors
      throw Exception('Failed to add room: $e');
    }
  }

  Future<void> deleteRoom(String? roomId) async {
    try {
      await apiService.deleteRequest('rooms/$roomId');
    } catch (e) {
      // Handle errors
      throw Exception('Failed to delete room: $e');
    }
  }

  Future<void> updateRoom(String? roomId, String? name) async {
    try {
      UpdateRoomRequest body = UpdateRoomRequest(name);
      await apiService.putRequest('rooms/$roomId', body.toJson());
    } catch (e) {
      // Handle errors
      throw Exception('Failed to update room: $e');
    }
  }

  Future<void> addDeviceToRoom(String? roomId, String? deviceId) async {
    try {
      AddDeviceToRoomRequest body = AddDeviceToRoomRequest(deviceId);
      await apiService.postRequest('rooms/$roomId/devices', body.toJson());
    } catch (e) {
      // Handle errors
      throw Exception('Failed to add device to room: $e');
    }
  }

  Future<void> removeDeviceFromRoom(String? roomId, String? deviceId) async {
    try {
      await apiService.deleteRequest('rooms/$roomId/devices/$deviceId');
    } catch (e) {
      // Handle errors
      throw Exception('Failed to remove device from room: $e');
    }
  }
}

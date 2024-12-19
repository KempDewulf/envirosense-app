import 'package:envirosense/data/models/add_room_request_model.dart';

import '../../services/api_service.dart';
import '../models/room_model.dart';

class RoomDataSource {
  final ApiService apiService;

  RoomDataSource({required this.apiService});

  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await apiService.getRequest('rooms');
      List<dynamic> data = response as List<dynamic>;
      List<RoomModel> rooms = data.map((roomJson) {
        return RoomModel.fromJson(
          roomJson
        );
      }).toList();
      return rooms;
    } catch (e) {
      // Handle errors
      throw Exception('Failed to load rooms: $e');
    }
  }

  Future<void> addRoom(String? name, String buildingId, String? roomTypeId) async {
    try {
      AddRoomRequest body = AddRoomRequest(name, buildingId, roomTypeId);

      await apiService.postRequest('rooms', body.toJson());
    } catch (e) {
      // Handle errors
      throw Exception('Failed to add room: $e');
    }
  }
}

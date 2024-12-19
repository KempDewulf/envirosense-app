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
          roomJson as Map<String, dynamic>,
        );
      }).toList();
      return rooms;
    } catch (e) {
      // Handle errors
      throw Exception('Failed to load rooms: $e');
    }
  }
}

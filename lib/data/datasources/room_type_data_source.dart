import 'package:envirosense/data/models/room_type_model.dart';
import 'package:envirosense/services/api_service.dart';

class RoomTypeDataSource {
  final ApiService apiService;

  RoomTypeDataSource({required this.apiService});

  Future<List<RoomTypeModel>> getRoomTypes(String buildingId) async {
    try {
      final response = await apiService.getRequest('room-types');

      List<dynamic> data = response.data as List<dynamic>;
      List<RoomTypeModel> roomTypes = data.map((roomTypeJson) {
        return RoomTypeModel.fromJson(
          roomTypeJson, buildingId
        );
      }).toList();
      return roomTypes;
    } catch (e) {
      // Handle errors
      throw Exception('Failed to load room types: $e');
    }
  }
}

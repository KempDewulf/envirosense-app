import 'package:envirosense/data/models/building_model.dart';
import '../../services/api_service.dart';

class BuildingDataSource {
  final ApiService apiService;

  BuildingDataSource({required this.apiService});

  Future<List<BuildingModel>> getBuildings() async {
    try {
      final response = await apiService.getRequest('buildings');
      
      List<dynamic> data = response.data as List<dynamic>;
      List<BuildingModel> buildings = data.map((buildingJson) {
        return BuildingModel.fromJson(
          buildingJson as Map<String, dynamic>,
        );
      }).toList();
      return buildings;
    } catch (e) {
      // Handle errors
      throw Exception('Failed to load buildings: $e');
    }
  }
}

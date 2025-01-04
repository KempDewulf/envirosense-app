import 'package:envirosense/data/models/building_air_quality.dart';
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

  Future<BuildingAirQualityModel> getBuildingAirQuality(String buildingId) async {
    try {
      final response = await apiService.getRequest('buildings/$buildingId/air-quality');
      print(response.data);
      return BuildingAirQualityModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // Handle errors
      throw Exception('Failed to load building air quality: $e');
    }
  }
}

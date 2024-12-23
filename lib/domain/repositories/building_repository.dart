import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/entities/building_air_quality.dart';

abstract class BuildingRepository {
  Future<List<Building>> getBuildings();
  Future<BuildingAirQuality> getBuildingAirQuality(String buildingId);
}
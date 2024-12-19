import 'package:envirosense/domain/entities/building.dart';

abstract class BuildingRepository {
  Future<List<Building>> getBuildings();
}
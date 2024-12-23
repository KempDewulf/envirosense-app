import 'package:envirosense/domain/entities/building_air_quality.dart';
import 'package:envirosense/domain/repositories/building_repository.dart';

class GetBuildingAirQualityUseCase {
  final BuildingRepository buildingRepository;

  GetBuildingAirQualityUseCase(this.buildingRepository);

  Future<BuildingAirQuality> execute(String buildingId) async{
    return await buildingRepository.getBuildingAirQuality(buildingId);
  }
}
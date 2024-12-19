import 'package:envirosense/data/datasources/building_data_source.dart';
import 'package:envirosense/data/repositories/building_repository_impl.dart';
import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/repositories/building_repository.dart';
import 'package:envirosense/domain/usecases/get_buildings.dart';
import '../../services/api_service.dart';

class BuildingController {
  late final GetBuildingsUseCase getBuildingsUseCase;
  final BuildingRepository repository;

  BuildingController()
      : repository = BuildingRepositoryImpl(
          remoteDataSource: BuildingDataSource(apiService: ApiService()),
        ) {
    getBuildingsUseCase = GetBuildingsUseCase(repository);
  }

  Future<List<Building>> fetchBuildings() async {
    return await getBuildingsUseCase();
  }
}

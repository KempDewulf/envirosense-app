import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/repositories/building_repository.dart';

class GetBuildingsUseCase {
  final BuildingRepository repository;

  GetBuildingsUseCase(this.repository);

  Future<List<Building>> call() async {
    return await repository.getBuildings();
  }
}

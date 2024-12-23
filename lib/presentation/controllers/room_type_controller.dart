import 'package:envirosense/data/datasources/room_type_data_source.dart';
import 'package:envirosense/data/repositories/room_type_repository_impl.dart';
import 'package:envirosense/domain/entities/room_type.dart';
import 'package:envirosense/domain/repositories/room_type_repository.dart';
import 'package:envirosense/domain/usecases/get_room_types.dart';

import '../../services/api_service.dart';

class RoomTypeController {
  late final GetRoomTypesUseCase getRoomTypesUseCase;
  final RoomTypeRepository repository;

  RoomTypeController()
      : repository = RoomTypeRepositoryImpl(
          remoteDataSource: RoomTypeDataSource(apiService: ApiService()),
        ) {
    getRoomTypesUseCase = GetRoomTypesUseCase(repository);
  }

  Future<List<RoomType>> getRoomTypes(String buildingId) async {
    return await getRoomTypesUseCase(buildingId);
  }
}

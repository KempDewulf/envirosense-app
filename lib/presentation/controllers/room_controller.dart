import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/data/repositories/room_repository_impl.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/repositories/room_repository.dart';
import '../../domain/usecases/get_rooms.dart';
import '../../domain/usecases/add_room.dart';
import '../../services/api_service.dart';

class RoomController {
  late final GetRoomsUseCase getRoomsUseCase;
  late final AddRoomUseCase addRoomUseCase;
  final RoomRepository repository;

  RoomController()
      : repository = RoomRepositoryImpl(
          remoteDataSource: RoomDataSource(apiService: ApiService()),
        ) {
    getRoomsUseCase = GetRoomsUseCase(repository);
    addRoomUseCase = AddRoomUseCase(repository);
  }

  Future<List<Room>> getRooms() async {
    return await getRoomsUseCase();
  }

  Future<void> addRoom(
      String? name, String buildingId, String? roomTypeId) async {
    print(name);
    print(buildingId);
    print(roomTypeId);
    return await addRoomUseCase(name, buildingId, roomTypeId);
  }
}

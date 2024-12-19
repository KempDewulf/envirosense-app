import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/data/repositories/room_repository_impl.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/repositories/room_repository.dart';
import 'package:envirosense/domain/usecases/add_room.dart';
import 'package:envirosense/domain/usecases/get_room_types.dart';
import 'package:envirosense/domain/usecases/remove_room.dart';
import '../../domain/usecases/get_rooms.dart';
import '../../services/api_service.dart';

class RoomController {
  late final GetRoomsUseCase getRoomsUseCase;
  late final AddRoomUseCase addRoomUseCase;
  late final RemoveRoomUseCase removeRoomUseCase;
  late final GetRoomTypesUseCase getRoomTypesUseCase;
  final RoomRepository repository;

  RoomController()
      : repository = RoomRepositoryImpl(
          remoteDataSource: RoomDataSource(apiService: ApiService()),
        ) {
    getRoomsUseCase = GetRoomsUseCase(repository);
    addRoomUseCase = AddRoomUseCase(repository);
    removeRoomUseCase = RemoveRoomUseCase(repository);
    getRoomTypesUseCase = GetRoomTypesUseCase(repository);
  }

  Future<List<Room>> fetchRooms() async {
    return await getRoomsUseCase();
  }

  Future<void> addRoom(Room room) async {
    await addRoomUseCase(room);
  }

  Future<void> removeRoom(String roomName) async {
    await removeRoomUseCase(roomName);
  }

  Future<List<Map<String, dynamic>>> fetchRoomTypes() async {
    return await getRoomTypesUseCase();
  }
}

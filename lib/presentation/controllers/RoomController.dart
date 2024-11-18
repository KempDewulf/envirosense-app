import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/data/repositories/room_repository_impl.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/repositories/room_repository.dart';
import 'package:envirosense/domain/usecases/add_room.dart';
import 'package:envirosense/domain/usecases/remove_room.dart';
import '../../domain/usecases/get_rooms.dart';

class RoomController {
  late final GetRoomsUseCase getRoomsUseCase;
  late final AddRoomUseCase addRoomUseCase;
  late final RemoveRoomUseCase removeRoomUseCase;
  final RoomRepository repository;

  RoomController()
      : repository = RoomRepositoryImpl(
          remoteDataSource: RoomDataSource(),
        ) {
    getRoomsUseCase = GetRoomsUseCase(repository);
    addRoomUseCase = AddRoomUseCase(repository);
    removeRoomUseCase = RemoveRoomUseCase(repository);
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
}

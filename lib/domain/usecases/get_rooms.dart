import '../entities/room.dart';
import '../repositories/room_repository.dart';

class GetRoomsUseCase {
  final RoomRepository repository;

  GetRoomsUseCase(this.repository);

  Future<List<Room>> call() async {
    return await repository.getRooms();
  }
}

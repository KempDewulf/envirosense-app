import '../entities/room.dart';
import '../repositories/room_repository.dart';

class GetRoomUseCase {
  final RoomRepository repository;

  GetRoomUseCase(this.repository);

  Future<Room> call(String roomId) async {
    return await repository.getRoom(roomId);
  }
}

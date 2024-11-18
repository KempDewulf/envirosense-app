import '../entities/room.dart';
import '../repositories/room_repository.dart';

class AddRoomUseCase {
  final RoomRepository repository;

  AddRoomUseCase(this.repository);

  Future<void> call(Room room) async {
    await repository.addRoom(room);
  }
}

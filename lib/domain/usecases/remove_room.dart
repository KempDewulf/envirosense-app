import '../repositories/room_repository.dart';

class RemoveRoomUseCase {
  final RoomRepository repository;

  RemoveRoomUseCase(this.repository);

  Future<void> call(String roomId) async {
    await repository.removeRoom(roomId);
  }
}

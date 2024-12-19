import '../repositories/room_repository.dart';

class AddRoomUseCase {
  final RoomRepository repository;

  AddRoomUseCase(this.repository);

  Future<void> call(name, buildingId, roomTypeId) async {
    return await repository.addRoom(name, buildingId, roomTypeId);
  }
}

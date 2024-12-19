import '../repositories/room_repository.dart';

class AddRoomUseCase {
  final RoomRepository repository;

  AddRoomUseCase(this.repository);

  Future<void> call(String? name, String buildingId, String? roomTypeId) async {
    return await repository.addRoom(name, buildingId, roomTypeId);
  }
}

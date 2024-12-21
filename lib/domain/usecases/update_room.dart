import 'package:envirosense/domain/repositories/room_repository.dart';

class UpdateRoomUseCase {
  final RoomRepository roomRepository;

  UpdateRoomUseCase(this.roomRepository);

  Future<void> call(String? roomId, String? name) async {
    return roomRepository.updateRoom(roomId, name);
  }
}
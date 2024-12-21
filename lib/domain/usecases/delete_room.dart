import 'package:envirosense/domain/repositories/room_repository.dart';

class DeleteRoomUseCase {
  final RoomRepository roomRepository;

  DeleteRoomUseCase(this.roomRepository);

  Future<void> call(String? roomId) async {
    return await roomRepository.deleteRoom(roomId);
  }
}
import 'package:envirosense/domain/repositories/room_repository.dart';

class RemoveDeviceFromRoomUseCase {
  final RoomRepository roomRepository;

  RemoveDeviceFromRoomUseCase(this.roomRepository);

  Future<void> call(String? roomId, String? deviceId) async {
    return await roomRepository.removeDeviceFromRoom(roomId, deviceId);
  }
}
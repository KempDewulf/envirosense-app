import 'package:envirosense/domain/repositories/room_repository.dart';

class AddDeviceToRoomUseCase {
  final RoomRepository repository;

  AddDeviceToRoomUseCase(this.repository);

  Future<void> call(String? roomId, String deviceId) async {
    return await repository.addDeviceToRoom(roomId, deviceId);
  }
}

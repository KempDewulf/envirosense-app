import 'package:envirosense/domain/entities/room_limits.dart';
import 'package:envirosense/domain/repositories/room_repository.dart';

class GetRoomLimitsUseCase {
  final RoomRepository _repository;

  GetRoomLimitsUseCase(this._repository);

  Future<RoomLimits> call(String roomId) async {
    return _repository.getRoomLimits(roomId);
  }
}

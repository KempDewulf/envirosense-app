import 'package:envirosense/domain/entities/room_air_quality.dart';
import 'package:envirosense/domain/repositories/room_repository.dart';

class GetRoomAirQualityUseCase {
  final RoomRepository _repository;

  GetRoomAirQualityUseCase(this._repository);

  Future<RoomAirQuality> call(String roomId) async {
    return _repository.getRoomAirQuality(roomId);
  }
}
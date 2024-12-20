import 'package:envirosense/domain/entities/air_quality.dart';
import 'package:envirosense/domain/repositories/room_repository.dart';

class GetAirQualityUseCase {
  final RoomRepository _repository;

  GetAirQualityUseCase(this._repository);

  Future<AirQuality> call(String roomId) async {
    return _repository.getAirQuality(roomId);
  }
}
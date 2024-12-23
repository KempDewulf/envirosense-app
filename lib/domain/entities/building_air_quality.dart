import 'package:envirosense/domain/entities/room_air_quality.dart';

class BuildingAirQuality {
  final String? enviroScore;
  final List<RoomAirQuality?>  roomsAirQuality;

  BuildingAirQuality({
    required this.enviroScore,
    required this.roomsAirQuality,
  });
}
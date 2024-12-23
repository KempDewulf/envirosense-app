import 'package:envirosense/domain/entities/air_data.dart';

class RoomAirQuality {
  final String id;
  final String? name;
  final double? enviroScore;
  final AirData? airData;

  RoomAirQuality({
    required this.id,
    this.name,
    this.enviroScore,
    this.airData,
  });

  @override
  String toString() {
    return 'AirQuality{id: $id, enviroScore: $enviroScore, airData: $airData}';
  }
}
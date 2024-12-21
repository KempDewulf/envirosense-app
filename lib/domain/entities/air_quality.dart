import 'package:envirosense/domain/entities/air_data.dart';

class AirQuality {
  final String id;
  final int? enviroScore;
  final AirData airData;

  AirQuality({
    required this.id,
    required this.enviroScore,
    required this.airData,
  });

  @override
  String toString() {
    return 'AirQuality{id: $id, enviroScore: $enviroScore, airData: $airData}';
  }
}
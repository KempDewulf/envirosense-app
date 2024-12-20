import 'package:envirosense/domain/entities/air_data.dart';

class AirQuality {
  final String id;
  final int enviroScore;
  final AirData airData;

  AirQuality({
    required this.id,
    required this.enviroScore,
    required this.airData,
  });
}
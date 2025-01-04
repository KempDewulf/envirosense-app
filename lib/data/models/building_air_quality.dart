import 'package:envirosense/data/models/room_air_quality_model.dart';
import 'package:envirosense/domain/entities/building_air_quality.dart';

class BuildingAirQualityModel extends BuildingAirQuality {
  BuildingAirQualityModel({
    required super.enviroScore,
    required super.roomsAirQuality,
  });

  factory BuildingAirQualityModel.fromJson(Map<String, dynamic> json) {
    double? parseEnviroScore(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return BuildingAirQualityModel(
      enviroScore: parseEnviroScore(json['enviroScore']),
      roomsAirQuality: (json['rooms'] as List)
          .map((e) => RoomAirQualityModel.fromJson(e))
          .toList(),
    );
  }
}

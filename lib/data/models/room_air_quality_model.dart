import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/entities/room_air_quality.dart';

class RoomAirQualityModel extends RoomAirQuality {
  RoomAirQualityModel({
    required super.id,
    super.name,
    super.enviroScore,
    super.airData,
  });

  factory RoomAirQualityModel.fromJson(Map<String, dynamic> json) {
    double? parseEnviroScore(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    if (json['airQuality'] == null) {
      return RoomAirQualityModel(
        id: json['documentId'],
        name: json['name'],
        enviroScore: parseEnviroScore(json['enviroScore']),
        airData: null,
      );
    }
    AirData airData = AirData(
      temperature: json['airQuality']['temperature'] != null
          ? (json['airQuality']['temperature'] is String
              ? double.tryParse(json['airQuality']['temperature'])
              : (json['airQuality']['temperature'] as num?)?.toDouble())
          : null,
      humidity: json['airQuality']['humidity'] != null
          ? (json['airQuality']['humidity'] is String
              ? double.tryParse(json['airQuality']['humidity'])
              : (json['airQuality']['humidity'] as num?)?.toDouble())
          : null,
      ppm: json['airQuality']['ppm'] != null
          ? (json['airQuality']['ppm'] is String ? int.tryParse(json['airQuality']['ppm']) : (json['airQuality']['ppm'] as num?)?.toInt())
          : null,
    );

    return RoomAirQualityModel(
      id: json['documentId'],
      enviroScore: parseEnviroScore(json['enviroScore']),
      airData: airData,
    );
  }
}

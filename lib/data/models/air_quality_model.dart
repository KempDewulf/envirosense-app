import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/entities/air_quality.dart';

class AirQualityModel extends AirQuality {
  AirQualityModel({
    required super.id,
    required super.enviroScore,
    required super.airData,
  });

  factory AirQualityModel.fromJson(Map<String, dynamic> json) {
    AirData airData = AirData(
      temperature: json['airQuality']['temperature'] is String
          ? double.parse(json['airQuality']['temperature'])
          : (json['airQuality']['temperature'] as num).toDouble(),
      humidity: json['airQuality']['humidity'] is String
          ? double.parse(json['airQuality']['humidity'])
          : (json['airQuality']['humidity'] as num).toDouble(),
      gasPpm: json['airQuality']['ppm'] is String
          ? int.parse(json['airQuality']['ppm'])
          : (json['airQuality']['ppm'] as num).toInt(),
    );

    return AirQualityModel(
      id: json['id'],
      enviroScore: json['enviroScore'],
      airData: airData,
    );
  }
}

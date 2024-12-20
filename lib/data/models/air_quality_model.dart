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
      gasPpm: json['airQuality']['ppm'] != null
          ? (json['airQuality']['ppm'] is String
              ? int.tryParse(json['airQuality']['ppm'])
              : (json['airQuality']['ppm'] as num?)?.toInt())
          : null,
    );

    return AirQualityModel(
      id: json['id'],
      enviroScore: json['enviroScore'],
      airData: airData,
    );
  }
}

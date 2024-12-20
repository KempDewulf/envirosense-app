
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
      temperature: json['airQuality']['temperature'], 
      humidity: json['airQuality']['humidity'], 
      gasPpm: json['airQuality']['ppm'],
    );

    return AirQualityModel(
      id: json['id'],
      enviroScore: json['enviroScore'],
      airData: airData,
    );
  }
}
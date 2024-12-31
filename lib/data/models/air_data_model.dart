import 'package:envirosense/domain/entities/air_data.dart';

class AirDataModel extends AirData {
  AirDataModel({
    required super.temperature,
    required super.humidity,
    required super.ppm,
  });

  factory AirDataModel.fromJson(Map<String, dynamic> json) {
    return AirDataModel(
      temperature: json['temperature'],
      humidity: json['humidity'],
      ppm: json['ppm'],
    );
  }
}

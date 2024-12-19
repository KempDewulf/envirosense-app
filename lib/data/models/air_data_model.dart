import 'package:envirosense/domain/entities/air_data.dart';

class AirDataModel extends AirData {
  AirDataModel({
    required super.temperature,
    required super.humidity,
    required super.gasPpm,
  });

  factory AirDataModel.fromJson(Map<String, dynamic> json) {
    return AirDataModel(
      temperature: json['temperature'],
      humidity: json['humidity'],
      gasPpm: json['gas_ppm'],
    );
  }
}

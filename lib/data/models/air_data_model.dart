import 'package:envirosense/domain/entities/air_data.dart';

class AirDataModel extends AirData {
  AirDataModel({
    required super.id,
    required super.device,
    required super.timestamp,
    required super.airData,
  });

  factory AirDataModel.fromJson(Map<String, dynamic> json) {
    return AirDataModel(
      id: json['documentId'],
      device: json['device'],
      timestamp: json['timestamp'],
      airData: json['airData'],
    );
  }
}

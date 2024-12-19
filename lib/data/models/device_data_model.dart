import 'package:envirosense/domain/entities/device_data.dart';

class DeviceDataModel extends DeviceData {
  DeviceDataModel({
    required super.id,
    required super.device,
    required super.timestamp,
    required super.airData,
  });

  factory DeviceDataModel.fromJson(Map<String, dynamic> json) {
    return DeviceDataModel(
      id: json['documentId'],
      device: json['device'],
      timestamp: json['timestamp'],
      airData: json['airData'],
    );
  }
}

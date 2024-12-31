import 'package:envirosense/data/models/device_model.dart';
import 'package:envirosense/domain/entities/air_data.dart';
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
      id: json['documentId'].toString(),
      device: DeviceModel.fromJson(json['device'], 'gox5y6bsrg640qb11ak44dh0'),
      timestamp: json['timestamp'],
      airData: AirData(
        temperature: json['airData']['temperature'],
        humidity: json['airData']['humidity'],
        ppm: json['airData']['ppm'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    DeviceModel d = device as DeviceModel;

    return {
      'documentId': id,
      'device': d.toJson(),
      'timestamp': timestamp,
      'airData': {
        'temperature': airData.temperature,
        'humidity': airData.humidity,
        'ppm': airData.ppm,
      },
    };
  }
}

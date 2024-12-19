import '../../domain/entities/device.dart';

class DeviceModel extends Device {
  DeviceModel({
    required super.id,
    required super.identifier,
    required super.room,
    super.deviceData,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['documentId'],
      identifier: json['identifier'],
      room: json['room'],
      deviceData: json['deviceData'],
    );
  }
}

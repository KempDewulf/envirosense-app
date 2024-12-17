import '../../domain/entities/device.dart';

class DeviceModel extends Device {
  DeviceModel({
    required super.id,
    required super.name, 
    required super.roomId,
    required super.roomName,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    final room = json['room'] as Map<String, dynamic>;
    return DeviceModel(
      id: json['documentId'] as String,
      name: json['identifier'] as String,
      roomId: room['documentId'] as String,
      roomName: room['name'] as String,
    );
  }
}
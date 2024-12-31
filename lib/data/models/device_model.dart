import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/entities/device_data.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/entities/room_type.dart';

import '../../domain/entities/device.dart';

class DeviceModel extends Device {
  DeviceModel({
    required super.id,
    required super.identifier,
    super.room,
    super.deviceData,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json, String buildingId) {
    Room? room = json['room'] != null ? Room(
        id: json['room']['documentId'],
        name: json['room']['name'],
        building: Building(
          id: buildingId,
          name: 'Campus Brugge Station - Building A',
          address: 'Spoorwegstraat 4, 8200 Brugge',
        ),
        roomType: RoomType(id: 'lorem', name: 'lorem', icon: 'lorem')) : null;


    List<DeviceData> deviceData = json['device_data'] != null
      ? (json['device_data'] as List)
        .map((deviceDataJson) => DeviceData(
            id: deviceDataJson['documentId'],
            timestamp: deviceDataJson['timestamp'],
            airData: AirData(
            temperature: deviceDataJson['temperature'] is String
              ? double.parse(deviceDataJson['temperature'])
              : (deviceDataJson['temperature'] as num).toDouble(),
            humidity: deviceDataJson['humidity'] is String
              ? double.parse(deviceDataJson['humidity'])
              : (deviceDataJson['humidity'] as num).toDouble(),
            ppm: deviceDataJson['ppm'] is String
              ? int.parse(deviceDataJson['ppm'])
              : (deviceDataJson['ppm'] as num).toInt(),
            ),
            device: Device(
            id: json['documentId'],
            identifier: json['identifier'],
            ),
          ))
        .toList()
      : [];

    return DeviceModel(
      id: json['documentId'],
      identifier: json['identifier'],
      room: room,
      deviceData: deviceData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentId': id,
      'identifier': identifier,
      'room': room,
      'device_data': deviceData,
    };
  }
}

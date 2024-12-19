import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/entities/device_data.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/entities/roomtype.dart';

import '../../domain/entities/device.dart';

class DeviceModel extends Device {
  DeviceModel({
    required super.id,
    required super.identifier,
    super.room,
    super.deviceData,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json, String buildingId) {
    Room room = Room(
        id: json['room']['documentId'],
        name: json['room']['name'],
        building: Building(
          id: buildingId,
          name: 'Campus Brugge Station - Building A',
          address: 'Spoorwegstraat 4, 8200 Brugge',
        ),
        roomType: RoomType(id: 'lorem', name: 'lorem', icon: 'lorem')
    );

    List<DeviceData> deviceData = (json['device_data'] as List)
        .map((deviceDataJson) => DeviceData(
            id: deviceDataJson['documentId'],
            timestamp: deviceDataJson['timestamp'],
            airData: AirData(
              temperature: double.parse(deviceDataJson['temperature']),
              humidity: double.parse(deviceDataJson['humidity']),
              gasPpm: double.parse(deviceDataJson['gas_ppm']),
            ),
            device: Device(
              id: json['documentId'],
              identifier: json['identifier'],
            )))
        .toList();

    return DeviceModel(
      id: json['documentId'],
      identifier: json['identifier'],
      room: room,
      deviceData: deviceData,
    );
  }
}

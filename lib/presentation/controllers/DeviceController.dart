
import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:flutter/material.dart';

class DeviceController {
  Future<List<Device>> fetchDevices() async {
    // Fetch devices from your data source
    // For now, return mock data
    return [
      Device(id: '1', name: 'Thermostat', room: new Room(id: "1", name: "2.201", icon: IconData(Icons.class_.codePoint), devices: 2)),
      Device(id: '2', name: 'Light Sensor', room: new Room(id: "2", name: "2.202", icon: IconData(Icons.class_.codePoint), devices: 2)),
      // Add more devices
    ];
  }
}
import 'package:envirosense/services/database_service.dart';

import '../domain/entities/device.dart';
import '../presentation/controllers/device_controller.dart';

class DeviceService {
  final DeviceController _deviceController;
  final DatabaseService _databaseService;

  DeviceService(this._deviceController) : _databaseService = DatabaseService();

  Future<void> renameDevice(String deviceIdentifier, String newName) async {
    if (deviceIdentifier.isEmpty) {
      throw Exception('Device identifier not found');
    }
    await _databaseService.setDeviceName(deviceIdentifier, newName);
  }

  Future<void> deleteDevice(String deviceIdentifier, String buildingId) async {
    if (deviceIdentifier.isEmpty) {
      throw Exception('Device identifier not found');
    }
    await _deviceController.deleteDevice(deviceIdentifier, buildingId);
  }

  Future<void> changeDeviceRoom({
    required String deviceId,
    required String deviceIdentifier,
    required String? currentRoomId,
    required String newRoomId,
    required Function(String, String?) removeDeviceFromRoom,
    required Function(String, String?) addDeviceToRoom,
  }) async {
    if (currentRoomId != null && currentRoomId.isNotEmpty) {
      await removeDeviceFromRoom(currentRoomId, deviceId);
    }

    await addDeviceToRoom(newRoomId, deviceId);
    await _databaseService.clearCacheForDevice(deviceIdentifier);
  }

  Future<Device> getDevice(String deviceIdentifier, String buildingId) async {
    if (deviceIdentifier.isEmpty) {
      throw Exception('Device identifier not found');
    }
    return await _deviceController.getDevice(deviceIdentifier, buildingId);
  }
}

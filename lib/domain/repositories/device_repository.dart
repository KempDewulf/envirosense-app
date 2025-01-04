import 'package:envirosense/core/enums/display_mode.dart';
import 'package:envirosense/core/enums/limit_type.dart';
import '../entities/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevices(String buildingId);
  Future<Device> getDevice(String deviceId, String buildingId);
  Future<String> addDevice(String? roomId, String? deviceIdentifier);
  Future<void> deleteDevice(String? deviceId, String? buildingId);
  Future<void> deleteDeviceData(String? deviceId);
  Future<void> updateDeviceUIMode(String deviceId, DisplayMode mode);
  Future<void> updateDeviceLimit(String deviceId, LimitType limitType, double value);
}

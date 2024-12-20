import '../entities/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevices(String buildingId);
  Future<Device> getDevice(String deviceId, String buildingId);
  Future<String> addDevice(String? roomId, String? deviceIdentifier);
}

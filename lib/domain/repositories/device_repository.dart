import '../entities/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevices(String buildingId);
  Future<String> addDevice(String? roomId, String? deviceIdentifier);
}

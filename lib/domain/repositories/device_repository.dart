import '../entities/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevices();
  Future<String> addDevice(String? roomId, String? deviceIdentifier);
}

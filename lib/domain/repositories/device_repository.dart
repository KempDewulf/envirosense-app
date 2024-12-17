import '../entities/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevices();
  Future<void> addDevice(Device device);
  Future<void> removeDevice(String deviceId);
}
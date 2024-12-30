import 'package:envirosense/domain/entities/device_data.dart';

abstract class DeviceDataRepository {
  Future<List<DeviceData>> getDeviceData();
  Future<List<DeviceData>> getDeviceDataByDeviceId(String deviceId);
}

import 'package:envirosense/domain/entities/device_data.dart';

abstract class DeviceDataRepository {
  Future<List<DeviceData>> getDeviceData();
}

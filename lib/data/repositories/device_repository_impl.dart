import 'package:envirosense/core/enums/config_type.dart';
import 'package:envirosense/core/enums/display_mode.dart';
import 'package:envirosense/core/enums/limit_type.dart';
import 'package:envirosense/data/datasources/device_data_source.dart';

import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceDataSource remoteDataSource;

  DeviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Device>> getDevices(String buildingId) async {
    return await remoteDataSource.getDevices(buildingId);
  }

  @override
  Future<Device> getDevice(String deviceId, String buildingId) async {
    return await remoteDataSource.getDevice(deviceId, buildingId);
  }

  @override
  Future<String> addDevice(String? roomId, String? deviceIdentifier) async {
    return await remoteDataSource.addDevice(roomId, deviceIdentifier);
  }

  @override
  Future<void> updateDeviceConfig(String deviceId, ConfigType configType, dynamic value) async {
    return await remoteDataSource.updateDeviceConfig(deviceId, configType, value);
  }

  @override
  Future<void> updateDeviceLimit(String deviceId, LimitType limitType, double value) async {
    return await remoteDataSource.updateDeviceLimit(deviceId, limitType, value);
  }

  @override
  Future<void> deleteDevice(String? deviceId, String? buildingId) async {
    return await remoteDataSource.deleteDevice(deviceId, buildingId);
  }

  @override
  Future<void> deleteDeviceData(String? deviceId) async {
    return await remoteDataSource.deleteDeviceData(deviceId);
  }
}

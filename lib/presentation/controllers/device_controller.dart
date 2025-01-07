import 'package:envirosense/core/enums/config_type.dart';
import 'package:envirosense/core/enums/limit_type.dart';
import 'package:envirosense/data/datasources/device_data_source.dart';
import 'package:envirosense/domain/entities/device_config.dart';
import 'package:envirosense/domain/usecases/add_device.dart';
import 'package:envirosense/domain/usecases/delete_device.dart';
import 'package:envirosense/domain/usecases/delete_device_data.dart';
import 'package:envirosense/domain/usecases/get_device.dart';
import 'package:envirosense/domain/usecases/get_device_config.dart';
import 'package:envirosense/domain/usecases/update_device_config.dart';
import 'package:envirosense/domain/usecases/update_device_limit.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/usecases/get_devices.dart';
import '../../services/api_service.dart';

class DeviceController {
  late final GetDevicesUseCase getDevicesUseCase;
  late final GetDeviceUseCase getDeviceUseCase;
  late final GetDeviceConfigUseCase getDeviceConfigUseCase;
  late final AddDeviceUseCase addDeviceUseCase;
  late final UpdateDeviceConfigUseCase updateDeviceConfigUseCase;
  late final UpdateDeviceLimitUseCase updateDeviceLimitUseCase;
  late final DeleteDeviceUseCase deleteDeviceUseCase;
  late final DeleteDeviceDataUseCase deleteDeviceDataUseCase;
  final DeviceRepository repository;

  DeviceController()
      : repository = DeviceRepositoryImpl(
          remoteDataSource: DeviceDataSource(apiService: ApiService()),
        ) {
    getDevicesUseCase = GetDevicesUseCase(repository);
    getDeviceUseCase = GetDeviceUseCase(repository);
    getDeviceConfigUseCase = GetDeviceConfigUseCase(repository);
    addDeviceUseCase = AddDeviceUseCase(repository);
    updateDeviceConfigUseCase = UpdateDeviceConfigUseCase(repository);
    updateDeviceLimitUseCase = UpdateDeviceLimitUseCase(repository);
    deleteDeviceUseCase = DeleteDeviceUseCase(repository);
    deleteDeviceDataUseCase = DeleteDeviceDataUseCase(repository);
  }

  Future<List<Device>> getDevices(String buildingId) async {
    return await getDevicesUseCase(buildingId);
  }

  Future<Device> getDevice(String deviceId, String buildingId) async {
    return await getDeviceUseCase(deviceId, buildingId);
  }

  Future<DeviceConfig> getDeviceConfig(String deviceId) async {
    return await getDeviceConfigUseCase(deviceId);
  }

  Future<String> addDevice(String? roomId, String? deviceIdentifier) async {
    return await addDeviceUseCase(roomId, deviceIdentifier);
  }

  Future<void> updateDeviceConfig(String deviceId, ConfigType configType, dynamic value) async {
    return await updateDeviceConfigUseCase(deviceId, configType, value);
  }

  Future<void> updateDeviceLimit(String deviceId, LimitType limitType, double value) async {
    return await updateDeviceLimitUseCase(deviceId, limitType, value);
  }

  Future<void> deleteDevice(String? deviceId, String? buildingId) async {
    return await deleteDeviceUseCase(deviceId, buildingId);
  }

  Future<void> deleteDeviceData(String? deviceId) async {
    return await deleteDeviceDataUseCase(deviceId);
  }
}

import 'package:envirosense/data/datasources/device_data_source.dart';
import 'package:envirosense/domain/usecases/add_device.dart';

import '../../data/repositories/device_repository_impl.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/usecases/get_devices.dart';
import '../../services/api_service.dart';

class DeviceController {
  late final GetDevicesUseCase getDevicesUseCase;
  late final AddDeviceUseCase addDeviceUseCase;
  final DeviceRepository repository;

  DeviceController()
      : repository = DeviceRepositoryImpl(
          remoteDataSource: DeviceDataSource(apiService: ApiService()),
        ) {
    getDevicesUseCase = GetDevicesUseCase(repository);
    addDeviceUseCase = AddDeviceUseCase(repository);
  }

  Future<List<Device>> getDevices() async {
    return await getDevicesUseCase();
  }

  Future<String> addDevice(String? roomId, String? deviceIdentifier) async {
    return await addDeviceUseCase(roomId, deviceIdentifier);
  }
}

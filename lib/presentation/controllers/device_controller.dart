import 'package:envirosense/data/datasources/device_data_source.dart';

import '../../data/repositories/device_repository_impl.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/usecases/get_devices.dart';
import '../../services/api_service.dart';

class DeviceController {
  late final GetDevicesUseCase getDevicesUseCase;
  final DeviceRepository repository;

  DeviceController()
      : repository = DeviceRepositoryImpl(
          remoteDataSource: DeviceDataSource(apiService: ApiService()),
        ) {
    getDevicesUseCase = GetDevicesUseCase(repository);
  }

  Future<List<Device>> fetchDevices() async {
    return await getDevicesUseCase();
  }

  // Implement addDevice and removeDevice methods if needed
}

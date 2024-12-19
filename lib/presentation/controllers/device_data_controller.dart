import 'package:envirosense/data/datasources/device_data_data_source.dart';
import 'package:envirosense/data/repositories/device_data_repository_impl.dart';
import 'package:envirosense/domain/entities/device_data.dart';
import 'package:envirosense/domain/repositories/device_data_repository.dart';
import 'package:envirosense/domain/usecases/get_device_data.dart';

import '../../services/api_service.dart';

class DeviceDataController {
  late final GetDeviceDataUseCase getDeviceDataUseCase;
  final DeviceDataRepository repository;

  DeviceDataController()
      : repository = DeviceDataRepositoryImpl(
          remoteDataSource: DeviceDataDataSource(apiService: ApiService()),
        ) {
    getDeviceDataUseCase = GetDeviceDataUseCase(repository);
  }

  Future<List<DeviceData>> getDeviceData() async {
    return await getDeviceDataUseCase();
  }
}

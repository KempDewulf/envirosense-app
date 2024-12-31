import 'package:envirosense/domain/entities/device_data.dart';
import 'package:envirosense/domain/repositories/device_data_repository.dart';

class GetDeviceDataByDeviceIdUseCase {
  final DeviceDataRepository repository;

  GetDeviceDataByDeviceIdUseCase(this.repository);

  Future<List<DeviceData>> call(String deviceId) async {
    return await repository.getDeviceDataByDeviceId(deviceId);
  }
}
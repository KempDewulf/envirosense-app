import 'package:envirosense/domain/entities/device_data.dart';
import 'package:envirosense/domain/repositories/device_data_repository.dart';

class GetDeviceDataUseCase {
  final DeviceDataRepository repository;

  GetDeviceDataUseCase(this.repository);

  Future<List<DeviceData>> call() async {
    return await repository.getDeviceData();
  }
}

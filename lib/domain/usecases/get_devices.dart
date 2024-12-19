import '../entities/device.dart';
import '../repositories/device_repository.dart';

class GetDevicesUseCase {
  final DeviceRepository repository;

  GetDevicesUseCase(this.repository);

  Future<List<Device>> call(String buildingId) async {
    return await repository.getDevices(buildingId);
  }
}

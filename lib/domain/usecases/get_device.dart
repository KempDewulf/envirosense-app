import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/domain/repositories/device_repository.dart';

class GetDeviceUseCase {
  final DeviceRepository repository;

  GetDeviceUseCase(this.repository);

  Future<Device> call(String deviceId, String buildingId) async {
    return await repository.getDevice(deviceId, buildingId);
  }
}

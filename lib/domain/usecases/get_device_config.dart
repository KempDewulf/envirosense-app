import 'package:envirosense/domain/entities/device_config.dart';
import 'package:envirosense/domain/repositories/device_repository.dart';

class GetDeviceConfigUseCase {
  final DeviceRepository repository;

  GetDeviceConfigUseCase(this.repository);

  Future<DeviceConfig> call(String deviceId) async {
    return repository.getDeviceConfig(deviceId);
  }
}

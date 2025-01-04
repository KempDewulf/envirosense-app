import 'package:envirosense/domain/repositories/device_repository.dart';

class UpdateDeviceLimitUseCase {
  final DeviceRepository repository;

  UpdateDeviceLimitUseCase(this.repository);

  Future<void> call(String deviceId, String limitType, double value) async {
    return await repository.updateDeviceLimit(deviceId, limitType, value);
  }
}

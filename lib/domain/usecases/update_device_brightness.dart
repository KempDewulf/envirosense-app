import 'package:envirosense/domain/repositories/device_repository.dart';

class UpdateDeviceBrightnessUseCase {
  final DeviceRepository repository;

  UpdateDeviceBrightnessUseCase(this.repository);

  Future<void> call(String deviceId, int value) async {
    return await repository.updateDeviceBrightness(deviceId, value);
  }
}

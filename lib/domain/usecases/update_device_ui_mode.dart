import 'package:envirosense/domain/repositories/device_repository.dart';
import 'package:envirosense/core/enums/display_mode.dart';

class UpdateDeviceUIModeUseCase {
  final DeviceRepository repository;

  UpdateDeviceUIModeUseCase(this.repository);

  Future<void> call(String deviceId, DisplayMode mode) async {
    return await repository.updateDeviceUIMode(deviceId, mode);
  }
}

import 'package:envirosense/core/enums/config_type.dart';
import 'package:envirosense/domain/repositories/device_repository.dart';

class UpdateDeviceConfigUseCase {
  final DeviceRepository repository;

  UpdateDeviceConfigUseCase(this.repository);

  Future<void> call(String deviceId, ConfigType limitType, dynamic value) async {
    return await repository.updateDeviceConfig(deviceId, limitType, value);
  }
}

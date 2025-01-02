import 'package:envirosense/domain/repositories/device_repository.dart';

class DeleteDeviceDataUseCase {
  final DeviceRepository _deviceRepository;

  DeleteDeviceDataUseCase(this._deviceRepository);

  Future<void> call(String? deviceId) async {
    return _deviceRepository.deleteDeviceData(deviceId);
  }
}

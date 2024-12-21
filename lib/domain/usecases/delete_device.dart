import 'package:envirosense/domain/repositories/device_repository.dart';

class DeleteDeviceUseCase {
  final DeviceRepository _deviceRepository;

  DeleteDeviceUseCase(this._deviceRepository);

  Future<void> call(String? deviceId, String? buildingId) async {
    return _deviceRepository.deleteDevice(deviceId, buildingId);
  }
}
import '../repositories/device_repository.dart';

class AddDeviceUseCase {
  final DeviceRepository repository;

  AddDeviceUseCase(this.repository);

  Future<String> call(String? roomId, String? deviceIdentifier) async {
    return await repository.addDevice(roomId, deviceIdentifier);
  }
}

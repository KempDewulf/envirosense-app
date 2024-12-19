import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_data_source.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceDataSource remoteDataSource;

  DeviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Device>> getDevices() async {
    return await remoteDataSource.getDevices();
  }
}
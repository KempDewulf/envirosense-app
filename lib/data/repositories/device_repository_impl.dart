import 'package:envirosense/data/datasources/device_data_source.dart';

import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceDataSource remoteDataSource;

  DeviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Device>> getDevices() async {
    return await remoteDataSource.getDevices();
  }
}

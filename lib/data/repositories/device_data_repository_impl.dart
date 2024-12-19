import 'package:envirosense/data/datasources/device_data_data_source.dart';
import 'package:envirosense/domain/entities/device_data.dart';
import 'package:envirosense/domain/repositories/device_data_repository.dart';

class DeviceDataRepositoryImpl implements DeviceDataRepository {
  final DeviceDataDataSource remoteDataSource;

  DeviceDataRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DeviceData>> getDeviceData() async {
    return await remoteDataSource.getDeviceData();
  }
}

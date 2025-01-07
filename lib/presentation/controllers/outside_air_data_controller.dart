import 'package:envirosense/data/datasources/outside_air_data_source.dart';
import 'package:envirosense/data/repositories/outside_air_data_repository_impl.dart';
import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/repositories/outside_air_data_repository.dart';
import 'package:envirosense/services/outside_air_api_service.dart';

class OutsideAirDataController {
  final OutsideAirDataRepository outsideAirDataRepository;

  OutsideAirDataController()
      : outsideAirDataRepository = OutsideAirDataRepositoryImpl(remoteDataSource: OutsideAirDataSource(outsideAirApiService: OutsideAirApiService()));

  Future<AirData> getOutsideAirData(String city) async {
    return outsideAirDataRepository.getOutsideAirData(city);
  }
}

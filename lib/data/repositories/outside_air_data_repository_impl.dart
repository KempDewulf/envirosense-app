import 'package:envirosense/data/datasources/outside_air_data_source.dart';
import 'package:envirosense/domain/entities/outside_air_data.dart';
import 'package:envirosense/domain/repositories/outside_air_data_repository.dart';

class OutsideAirDataRepositoryImpl extends OutsideAirDataRepository {
  final OutsideAirDataSource remoteDataSource;

  OutsideAirDataRepositoryImpl({required this.remoteDataSource});
  @override
  Future<OutsideAirData> getOutsideAirData(String city) async{
    return await remoteDataSource.getOutsideAir(city);
  }
}
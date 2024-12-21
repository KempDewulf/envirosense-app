import 'package:envirosense/domain/entities/outside_air_data.dart';
import 'package:envirosense/domain/repositories/outside_air_data_repository.dart';

class GetOutsideAirDataUseCase {
  final OutsideAirDataRepository outsideAirDataRepository;

  GetOutsideAirDataUseCase(this.outsideAirDataRepository);

  Future<OutsideAirData> execute(String city) async {
    return await outsideAirDataRepository.getOutsideAirData(city);
  }
}
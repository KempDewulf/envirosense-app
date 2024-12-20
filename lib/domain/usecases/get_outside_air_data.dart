import 'package:envirosense/domain/entities/outside_air_data.dart';
import 'package:envirosense/domain/repositories/outside_air_data_repository.dart';

class GetOutsideAirDataUseCase {
  final OutsideAirDataRepository _outsideAirDataRepository;

  GetOutsideAirDataUseCase(this._outsideAirDataRepository);

  Future<OutsideAirData> execute(String city) {
    return _outsideAirDataRepository.getOutsideAirData(city);
  }
}
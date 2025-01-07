import 'package:envirosense/domain/entities/outside_air_data.dart';

abstract class OutsideAirDataRepository {
  Future<OutsideAirData> getOutsideAirData(String city);
}

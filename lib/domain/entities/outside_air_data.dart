import 'package:envirosense/domain/entities/air_data.dart';

class OutsideAirData extends AirData{
  OutsideAirData({
    required double temperature,
    required double humidity,
    int gasPpm = 400,
  }) : super(
    temperature: temperature,
    humidity: humidity,
    gasPpm: gasPpm,
  );
}
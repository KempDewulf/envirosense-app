import 'package:envirosense/domain/entities/air_data.dart';

class WeatherController {


  //mockdata

  AirData getOutsideAirData() { 
    return AirData(
      temperature: 25,
      humidity: 50,
      gasPpm: 400,
    );
  }
}
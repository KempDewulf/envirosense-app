import 'package:envirosense/domain/entities/device.dart';

class RoomOverviewController {
  Map<String, Map<String, String>> getRoomData(String roomName) {
    //TODO: implement API call
    return {
      'Temperature': {'value': '22°C', 'status': 'good'},
      'Humidity': {'value': '45%', 'status': 'medium'},
      'Air Quality': {'value': '350 ppm', 'status': 'bad'},
    };
  }

  Map<String, Map<String, String>> getOutsideData() {
    //TODO: implement API call
    return {
      'Temperature': {'value': '18°C', 'status': 'medium'},
      'Humidity': {'value': '55%', 'status': 'good'},
      'Air Quality': {'value': '400 ppm', 'status': 'bad'},
    };
  }
  //get enviroscore
  Map<String, Map<String, String>> getEnviroScore() {
    return {
      'EnviroScore': {'value': '75', 'status': 'good'},
    };
  }

  Map<String, List<double>> getChartData() {
    // TODO: Implement API call to get historical data
    return {
      'temperature': [22, 23, 21, 24, 22],
      'humidity': [45, 47, 44, 46, 45],
      'airQuality': [350, 360, 340, 355, 350],
    };
  }

  Future<List<Device>> getRoomDevices(String roomId) async {
    // TODO: Implement API call to get devices in room
    return [];
  }

  double getTargetTemperature() {
    // TODO: Implement API call to get target temperature
    return 22.0;
  }

  Future<void> setTargetTemperature(double temperature) async {
    // TODO: Implement API call to set target temperature
  }
}

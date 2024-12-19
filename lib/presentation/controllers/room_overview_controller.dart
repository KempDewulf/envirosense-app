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
}

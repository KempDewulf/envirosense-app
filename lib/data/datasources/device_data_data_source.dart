import 'package:envirosense/data/models/device_data_model.dart';
import '../../services/api_service.dart';

class DeviceDataDataSource {
  final ApiService apiService;

  DeviceDataDataSource({required this.apiService});

  Future<List<DeviceDataModel>> getDeviceData() async {
    try {
      final response = await apiService.getRequest('device-data');

      if (response == null) {
        throw Exception('Response is null');
      }

      List<dynamic> data = response as List<dynamic>;
      List<DeviceDataModel> deviceData = data.map((deviceDataJson) {
        return DeviceDataModel.fromJson(deviceDataJson as Map<String, dynamic>);
      }).toList();

      return deviceData;
    } catch (e) {
      throw Exception('Failed to load device data: $e');
    }
  }
}
import 'package:envirosense/core/enums/config_type.dart';
import 'package:envirosense/core/enums/limit_type.dart';
import 'package:envirosense/data/models/add_device_request_model.dart';
import 'package:envirosense/data/models/device_model.dart';
import '../../services/api_service.dart';

class DeviceDataSource {
  final ApiService apiService;

  DeviceDataSource({required this.apiService});

  Future<List<DeviceModel>> getDevices(String buildingId) async {
    try {
      final response = await apiService.getRequest('devices');

      List<dynamic> data = response.data as List<dynamic>;
      List<DeviceModel> devices = data.map((deviceJson) {
        return DeviceModel.fromJson(
            deviceJson as Map<String, dynamic>, buildingId);
      }).toList();

      return devices;
    } catch (e) {
      throw Exception('Failed to load devices: $e');
    }
  }

  Future<DeviceModel> getDevice(String deviceId, String buildingId) async {
    try {
      final response = await apiService.getRequest('devices/$deviceId');
      return DeviceModel.fromJson(response.data, '');
    } catch (e) {
      throw Exception('Failed to load device: $e');
    }
  }

  Future<String> addDevice(String? roomId, String? deviceIdentifier) async {
    try {
      AddDeviceRequest body = AddDeviceRequest(roomId, deviceIdentifier);

      final response = await apiService.postRequest('devices', body.toJson());
      final locationHeader = response.headers['location'];
      if (locationHeader == null) {
        throw Exception('Device ID not found in response headers');
      }

      return locationHeader.split('/').last;
    } catch (e) {
      throw Exception('Failed to add device: $e');
    }
  }

  Future<void> updateDeviceConfig(String deviceId, ConfigType configType, dynamic value) async {
    try {
      await apiService.patchRequest('devices/$deviceId/config/${configType.toApiString}', {
        'value': value,
      });
    } catch (e) {
      throw Exception('Failed to update device config: $e');
    }
  }

  Future<void> updateDeviceLimit(
      String deviceId, LimitType limitType, double value) async {
    try {
      await apiService
          .patchRequest('devices/$deviceId/limits/${limitType.toApiString}', {
        'value': value,
      });
    } catch (e) {
      throw Exception('Failed to update device limit: $e');
    }
  }

  Future<void> deleteDevice(String? deviceId, String? buildingId) async {
    try {
      await apiService.deleteRequest('devices/$deviceId');
    } catch (e) {
      throw Exception('Failed to delete device: $e');
    }
  }

  Future<void> deleteDeviceData(String? deviceId) async {
    try {
      await apiService.deleteRequest('devices/$deviceId/device-data');
    } catch (e) {
      throw Exception('Failed to delete device: $e');
    }
  }
}

import 'package:envirosense/data/models/device_data_model.dart';
import 'package:envirosense/services/database_service.dart';
import '../../services/api_service.dart';

class DeviceDataDataSource {
  final ApiService apiService;
  final DatabaseService databaseService = DatabaseService();

  DeviceDataDataSource({required this.apiService});

  Future<List<DeviceDataModel>> getDeviceData() {
    throw UnimplementedError();
  }

  Future<List<DeviceDataModel>> getDeviceDataByDeviceId(String deviceId) {
    return _getDeviceData(deviceId);
  }

  Future<List<DeviceDataModel>> _getDeviceData(
    String deviceId,{
    Duration cacheDuration = const Duration(days: 1),
  }) async {
    final cachedTimestamp = await databaseService.getCacheTimestamp(deviceId);
    final cachedData = await _retrieveCachedData(deviceId, cachedTimestamp);

    final remoteEndpoint = _buildEndpoint('device-data', cachedTimestamp, deviceId: deviceId);
    final newData = await _fetchNetworkData(remoteEndpoint);

    final latestTimestamp = _extractLatestTimestamp(newData, cachedTimestamp);
    final mergedData = _mergeCachedData(newData, cachedData, deviceId);

    if (latestTimestamp != null) {
      await _storeDataToCache(deviceId, mergedData, latestTimestamp, cacheDuration);
    }
    return mergedData;
  }

  List<DeviceDataModel> _mergeCachedData(
    List<DeviceDataModel> freshData,
    List<DeviceDataModel>? cachedData,
    String deviceId,
  ) {
    if (cachedData == null || cachedData.isEmpty) return freshData;
    return [...freshData, ...cachedData];
  }

  Future<List<DeviceDataModel>?> _retrieveCachedData(
  String key,
  DateTime? cachedTimestamp,
) async {
  if (cachedTimestamp == null) return null;
  final List<DeviceDataModel>? cachedData = await databaseService.getCache<List<DeviceDataModel>>(key);
  return cachedData;
}

  String _buildEndpoint(String base, DateTime? cachedTimestamp, {String? deviceId}) {
    final buffer = StringBuffer(base);
    bool hasQuery = false;
    if (deviceId != null) {
      buffer.write('?identifier=$deviceId');
      hasQuery = true;
    }
    if (cachedTimestamp != null) {
      final encodedTimestamp = '${Uri.encodeComponent(cachedTimestamp.toIso8601String())}Z';
      buffer.write(hasQuery ? '&' : '?');
      buffer.write('since=$encodedTimestamp');
    }
    return buffer.toString();
  }

  Future<List<DeviceDataModel>> _fetchNetworkData(String endpoint) async {
    final response = await apiService.getRequest(endpoint);
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((deviceDataJson) {
      return DeviceDataModel.fromJson(deviceDataJson as Map<String, dynamic>);
    }).toList();
  }

  DateTime? _extractLatestTimestamp(
    List<DeviceDataModel> deviceData,
    DateTime? cachedTimestamp,
  ) {
    if (deviceData.isEmpty) {
      return cachedTimestamp;
    }
    return DateTime.parse(deviceData.first.timestamp);
  }

  Future<void> _storeDataToCache(
    String key,
    List<DeviceDataModel> data,
    DateTime latestTimestamp,
    Duration cacheDuration,
  ) async {
    await databaseService.setCache(key, data, latestTimestamp, cacheDuration);
  }
}
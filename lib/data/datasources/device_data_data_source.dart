import 'package:envirosense/data/models/device_data_model.dart';
import 'package:envirosense/services/database_service.dart';
import 'package:logging/logging.dart';
import '../../services/api_service.dart';

class DeviceDataDataSource {
  final ApiService apiService;
  final DatabaseService databaseService = DatabaseService();

  DeviceDataDataSource({required this.apiService});

  Future<List<DeviceDataModel>> getDeviceData() {
    return _getDeviceData('device-data');
  }

  Future<List<DeviceDataModel>> getDeviceDataByDeviceId(String deviceId) {
    return _getDeviceData('device-data', deviceId: deviceId);
  }

  Future<List<DeviceDataModel>> _getDeviceData(
    String baseKey, {
    String? deviceId,
    Duration cacheDuration = const Duration(days: 1),
  }) async {
    final cachedTimestamp = await databaseService.getCacheTimestamp(baseKey);
    final cachedData = await _retrieveCachedData(baseKey, cachedTimestamp);
    
    print(cachedData);

    final remoteEndpoint = _buildEndpoint(baseKey, cachedTimestamp, deviceId: deviceId);

    print(remoteEndpoint);

    final newData = await _fetchNetworkData(remoteEndpoint);

    final latestTimestamp = _extractLatestTimestamp(newData, cachedTimestamp);
    final mergedData = _mergeCachedData(newData, cachedData);

    print(mergedData);

    await _storeDataToCache(baseKey, mergedData, latestTimestamp, cacheDuration);
    return mergedData;
  }

  List<DeviceDataModel> _mergeCachedData(
    List<DeviceDataModel> freshData,
    List<DeviceDataModel>? cachedData,
  ) {
    if (cachedData == null || cachedData.isEmpty) return freshData;
    return [...freshData, ...cachedData];
  }

  Future<List<DeviceDataModel>?> _retrieveCachedData(
    String key,
    DateTime? cachedTimestamp,
  ) async {
    if (cachedTimestamp == null) return null;
    final rawCache = await databaseService.getCache(key);
    if (rawCache == null) return null;
    return List<DeviceDataModel>.from(rawCache);
  }

  String _buildEndpoint(String base, DateTime? cachedTimestamp, {String? deviceId}) {
    final buffer = StringBuffer(base);
    bool hasQuery = false;
    if (deviceId != null) {
      buffer.write('?identifier=$deviceId');
      hasQuery = true;
    }
    if (cachedTimestamp != null) {
      final encodedTimestamp = Uri.encodeComponent(cachedTimestamp.toString());
      buffer.write(hasQuery ? '&' : '?');
      buffer.write('since=$encodedTimestamp');
    }
    return buffer.toString();
  }

  Future<List<DeviceDataModel>> _fetchNetworkData(String endpoint) async {
    final response = await apiService.getRequest(endpoint);
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => DeviceDataModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  DateTime _extractLatestTimestamp(
    List<DeviceDataModel> deviceData,
    DateTime? cachedTimestamp,
  ) {
    if (deviceData.isEmpty) {
      return cachedTimestamp ?? DateTime.now();
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
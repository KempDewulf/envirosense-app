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

  Future<List<DeviceDataModel>> getDeviceDataByDeviceId(String deviceIdentifier) {
    return _getDeviceData(deviceIdentifier);
  }

  Future<List<DeviceDataModel>> _getDeviceData(
    String deviceIdentifier,{
    Duration cacheDuration = const Duration(days: 1),
  }) async {
    final cachedTimestamp = await databaseService.getCacheTimestamp(deviceIdentifier);
    final cachedData = await _retrieveCachedData(deviceIdentifier, cachedTimestamp);

    final remoteEndpoint = _buildEndpoint('device-data', cachedTimestamp, deviceIdentifier: deviceIdentifier);
    final newData = await _fetchFreshData(remoteEndpoint);

    final latestTimestamp = _extractLatestTimestamp(newData, cachedTimestamp);
    final mergedData = _mergeCachedData(newData, cachedData, deviceIdentifier);

    if (latestTimestamp != null) {
      await _storeDataToCache(deviceIdentifier, mergedData, latestTimestamp, cacheDuration);
    }
    return mergedData;
  }

  List<DeviceDataModel> _mergeCachedData(
    List<DeviceDataModel> freshData,
    List<DeviceDataModel>? cachedData,
    String deviceIdentifier,
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

  String _buildEndpoint(String base, DateTime? cachedTimestamp, {String? deviceIdentifier}) {
    final buffer = StringBuffer(base);
    bool hasQuery = false;
    if (deviceIdentifier != null) {
      buffer.write('?identifier=$deviceIdentifier');
      hasQuery = true;
    }
    if (cachedTimestamp != null) {
      final encodedTimestamp = Uri.encodeComponent(cachedTimestamp.toIso8601String());
      buffer.write(hasQuery ? '&' : '?');
      buffer.write('since=$encodedTimestamp');
    }
    return buffer.toString();
  }

  Future<List<DeviceDataModel>> _fetchFreshData(String endpoint) async {
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
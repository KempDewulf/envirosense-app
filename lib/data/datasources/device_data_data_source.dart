import 'package:envirosense/data/models/device_data_model.dart';
import 'package:envirosense/services/database_service.dart';
import '../../services/api_service.dart';

class DeviceDataDataSource {
  final ApiService apiService;
  final DatabaseService databaseService = DatabaseService();

  DeviceDataDataSource({required this.apiService});

  Future<List<DeviceDataModel>> getDeviceData() async {
    try {
      final String endpointBase = 'device-data';
      final Duration cacheDuration = const Duration(days: 1);

      final cachedTimestamp = await databaseService.getCacheTimestamp(endpointBase);
      final cachedData = await _retrieveCachedData(endpointBase, cachedTimestamp);

      final remoteEndpoint = _buildRemoteEndpoint(endpointBase, cachedTimestamp);
      final newData = await _fetchNetworkData(remoteEndpoint);

      final latestTimestamp = _extractLatestTimestamp(newData, cachedTimestamp);
      final mergedData = _mergeCachedData(newData, cachedData);

      await _storeDataToCache(endpointBase, mergedData, latestTimestamp, cacheDuration);

      return mergedData;
    } catch (e) {
      throw Exception('Failed to load device data: $e');
    }
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

  String _buildRemoteEndpoint(String base, DateTime? cachedTimestamp) {
    if (cachedTimestamp == null) return base;
    final encodedTimestamp = Uri.encodeComponent(cachedTimestamp.toString());
    return '$base?since=$encodedTimestamp';
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
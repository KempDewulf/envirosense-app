import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceStorageHelper {
  static final DeviceStorageHelper _instance = DeviceStorageHelper._internal();

  factory DeviceStorageHelper() {
    return _instance;
  }

  DeviceStorageHelper._internal();

  static const String _storageKey = 'device_names';

  /// Fetches the custom name for a given device identifier.
  ///
  /// Returns the custom name if it exists, otherwise returns `null`.
  Future<String?> getDeviceName(String identifier) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedMappings = prefs.getString(_storageKey);
    if (storedMappings != null) {
      final Map<String, dynamic> deviceMappings =
          Map<String, dynamic>.from(json.decode(storedMappings));
      return deviceMappings[identifier] as String? ?? identifier;
    }
    return identifier;
  }

  /// Sets or updates the custom name for a given device identifier.
  ///
  /// This method persists the custom name in SharedPreferences.
  Future<void> setDeviceName(String identifier, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedMappings = prefs.getString(_storageKey);
    Map<String, dynamic> deviceMappings;
    if (storedMappings != null) {
      deviceMappings = Map<String, dynamic>.from(json.decode(storedMappings));
    } else {
      deviceMappings = {};
    }
    deviceMappings[identifier] = name;
    await prefs.setString(_storageKey, json.encode(deviceMappings));
  }

  /// Removes the custom name for a given device identifier.
  Future<void> removeDeviceName(String identifier) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedMappings = prefs.getString(_storageKey);
    if (storedMappings != null) {
      final Map<String, dynamic> deviceMappings =
          Map<String, dynamic>.from(json.decode(storedMappings));
      deviceMappings.remove(identifier);
      await prefs.setString(_storageKey, json.encode(deviceMappings));
    }
  }

  /// Clears all custom device names.
  Future<void> clearAllDeviceNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

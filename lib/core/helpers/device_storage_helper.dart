import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceStorageHelper {
  static const String _deviceNamesKey = 'device_names';

  /// Fetches the custom name for a given device identifier.
  static Future<String?> getDeviceName(String deviceIdentifier) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedMappings = prefs.getString(_deviceNamesKey);
    if (storedMappings != null) {
      final Map<String, dynamic> deviceMappings =
          Map<String, dynamic>.from(json.decode(storedMappings));
      return deviceMappings[deviceIdentifier] as String?;
    }
    return null;
  }

  /// Sets a custom name for a given device identifier.
  static Future<void> setDeviceName(
      String deviceIdentifier, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedMappings = prefs.getString(_deviceNamesKey);
    Map<String, dynamic> deviceMappings = storedMappings != null
        ? Map<String, dynamic>.from(json.decode(storedMappings))
        : {};
    deviceMappings[deviceIdentifier] = name;
    await prefs.setString(_deviceNamesKey, json.encode(deviceMappings));
  }

  /// Removes the custom name for a given device identifier.
  static Future<void> removeDeviceName(String deviceIdentifier) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedMappings = prefs.getString(_deviceNamesKey);
    if (storedMappings != null) {
      final Map<String, dynamic> deviceMappings =
          Map<String, dynamic>.from(json.decode(storedMappings));
      deviceMappings.remove(deviceIdentifier);
      await prefs.setString(_deviceNamesKey, json.encode(deviceMappings));
    }
  }

  /// Fetches all saved devices as a map.
  static Future<Map<String, String>> getAllDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedMappings = prefs.getString(_deviceNamesKey);
    if (storedMappings != null) {
      return Map<String, String>.from(json.decode(storedMappings));
    }
    return {};
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:envirosense/data/models/device_data_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB("envirosense.db");
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, filePath),
      onCreate: (db, version) async {
        // Settings table for app configuration
        await db.execute('''
          CREATE TABLE settings (
            key TEXT PRIMARY KEY,
            value TEXT,
            timestamp INTEGER
          )
        ''');

        // Device names table
        await db.execute('''
          CREATE TABLE device_names (
            device_id TEXT PRIMARY KEY,
            custom_name TEXT,
            timestamp INTEGER
          )
        ''');

        // Cache table for future use
        await db.execute('''
          CREATE TABLE cache (
            key TEXT PRIMARY KEY,
            value TEXT,
            timestamp INTEGER,
            expiration INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  // Settings Methods
  Future<void> setSetting(String key, dynamic value) async {
    final db = await database;
    await db.insert(
      'settings',
      {
        'key': key,
        'value': json.encode(value),
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<T?> getSetting<T>(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isEmpty) return null;
    return json.decode(maps.first['value']) as T;
  }

  // Device naming methods
  Future<void> setDeviceName(String deviceId, String customName) async {
    final db = await database;
    await db.insert(
      'device_names',
      {
        'device_id': deviceId,
        'custom_name': customName,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getDeviceName(String deviceId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'device_names',
      where: 'device_id = ?',
      whereArgs: [deviceId],
    );

    if (maps.isEmpty) return deviceId;
    return maps.first['custom_name'] as String;
  }

  Future<void> removeDeviceName(String deviceId) async {
    final db = await database;
    await db.delete(
      'device_names',
      where: 'device_id = ?',
      whereArgs: [deviceId],
    );
  }

  // Cache methods (for future use)
  Future<void> setCache(String key, dynamic value, DateTime latestTimestamp, Duration expiration) async {
    final db = await database;
    final existingExpiration = await getCacheExpiration(key);

    final expirationTime =
        existingExpiration != null ? existingExpiration.millisecondsSinceEpoch : latestTimestamp.millisecondsSinceEpoch + expiration.inMilliseconds;

    final jsonValue = value is List ? json.encode(value.map((item) => item.toJson()).toList()) : json.encode(value.toJson());

    await db.insert(
      'cache',
      {
        'key': key,
        'value': jsonValue,
        'timestamp': latestTimestamp.millisecondsSinceEpoch,
        'expiration': expirationTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DateTime?> getCacheTimestamp(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      columns: ['timestamp'],
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isEmpty) return null;
    return DateTime.fromMillisecondsSinceEpoch(maps.first['timestamp'] as int, isUtc: true);
  }

  Future<DateTime?> getCacheExpiration(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      columns: ['expiration'],
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isEmpty) return null;
    return DateTime.fromMillisecondsSinceEpoch(maps.first['expiration'] as int, isUtc: true);
  }

  Future<T?> getCache<T>(String key) async {
    final db = await database;

    if (await getCacheExpiration(key) != null) {
      await clearExpiredCache();
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isEmpty) return null;

    final decodedValue = json.decode(maps.first['value']) as dynamic;

    if (T == List<DeviceDataModel>) {
      return (decodedValue as List).map((item) => DeviceDataModel.fromJson(item as Map<String, dynamic>)).toList() as T;
    }

    // Handle other types if necessary
    return decodedValue as T;
  }

  Future<void> clearCacheForDevice(String deviceIdentifier) async {
    final db = await database;

    // Clear cache entries for specific device
    await db.delete(
      'cache',
      where: 'key LIKE ?',
      whereArgs: ['%$deviceIdentifier%'],
    );
  }

  Future<void> clearExpiredCache() async {
    final db = await database;
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await db.delete(
      'cache',
      where: 'expiration <= ?',
      whereArgs: [now],
    );
  }

  // Utility methods
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('settings');
    await db.delete('device_names');
    await db.delete('cache');
  }

  Future<void> clearDeviceDataCache() async {
    final db = await database;
    await db.delete(
      'cache',
    );
  }

  Future<void> clearDeviceNames() async {
    final db = await database;
    await db.delete(
      'device_names',
    );
  }
}

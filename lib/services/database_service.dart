import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  final Map<String, dynamic> _cache = {};

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
    // Update memory cache immediately
    _cache[key] = value;

    final db = await database;
    await db.insert(
      'settings',
      {
        'key': key,
        'value': json.encode(value),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<T?> getSetting<T>(String key) async {
    // Check memory cache first
    if (_cache.containsKey(key)) {
      return _cache[key] as T?;
    }

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isEmpty) return null;

    final value = json.decode(maps.first['value']) as T;
    // Store in memory cache
    _cache[key] = value;
    return value;
  }

  // Login timestamp specific methods
  Future<void> updateLoginTimestamp() async {
    await setSetting('loginTimestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> isLoginValid() async {
    // Check memory cache first for instant response
    if (_cache.containsKey('loginTimestamp')) {
      final timestamp = _cache['loginTimestamp'] as int?;
      if (timestamp != null) {
        final loginTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        return DateTime.now().difference(loginTime).inDays < 2;
      }
    }

    final timestamp = await getSetting<int>('loginTimestamp');
    if (timestamp == null) return false;

    final loginTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(loginTime).inDays < 2;
  }

  // Device naming methods
  Future<void> setDeviceName(String deviceId, String customName) async {
    final db = await database;
    await db.insert(
      'device_names',
      {
        'device_id': deviceId,
        'custom_name': customName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
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

    if (maps.isEmpty) return null;
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
  Future<void> setCache(String key, dynamic value, Duration expiration) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insert(
      'cache',
      {
        'key': key,
        'value': json.encode(value),
        'timestamp': now,
        'expiration': now + expiration.inMilliseconds,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<T?> getCache<T>(String key) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      where: 'key = ? AND expiration > ?',
      whereArgs: [key, now],
    );

    if (maps.isEmpty) return null;
    return json.decode(maps.first['value']) as T;
  }

  Future<void> clearExpiredCache() async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
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
}

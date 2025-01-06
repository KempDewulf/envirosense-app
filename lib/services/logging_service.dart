import 'package:logging/logging.dart';

class LoggingService {
  static final Logger _logger = Logger('AppLogger');

  static void initialize() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  static void logInfo(String? message) {
    _logger.info(message);
  }

  static void logError(String? message, [dynamic error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }
}

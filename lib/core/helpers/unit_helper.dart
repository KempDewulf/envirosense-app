import 'package:shared_preferences/shared_preferences.dart';

class UnitConverter {
  static Future<bool> getUseImperialUnits() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useImperialUnits') ?? false;
  }

  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  static Future<String> formatTemperature(double? celsius) async {
    if (celsius == null) return 'N/A';

    final useImperial = await getUseImperialUnits();
    if (useImperial) {
      final fahrenheit = celsiusToFahrenheit(celsius);
      return '${fahrenheit.toStringAsFixed(1)}°F';
    }
    return '${celsius.toStringAsFixed(1)}°C';
  }
}

import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/domain/entities/air_data.dart';
import 'package:flutter/material.dart';

class DataDisplayBox extends StatelessWidget {
  final String title;
  final AirData data;

  const DataDisplayBox({
    super.key,
    required this.title,
    required this.data,
  });

  Status _getStatus(num value, {
    required num min,
    required num max,
    required num optimalMin,
    required num optimalMax,
  }) {
    if (value < min || value > max) return Status.bad;
    if (value < optimalMin || value > optimalMax) return Status.medium;
    return Status.good;
  }

  Status _getTemperatureStatus(double temp) {
    return _getStatus(
      temp,
      min: Thresholds.temperature.min,
      max: Thresholds.temperature.max,
      optimalMin: Thresholds.temperature.optimalMin,
      optimalMax: Thresholds.temperature.optimalMax,
    );
  }

  Status _getHumidityStatus(double humidity) {
    return _getStatus(
      humidity,
      min: Thresholds.humidity.min,
      max: Thresholds.humidity.max,
      optimalMin: Thresholds.humidity.optimalMin,
      optimalMax: Thresholds.humidity.optimalMax,
    );
  }

  Status _getAirQualityStatus(int ppm) {
    if (ppm > Thresholds.airQuality.max) return Status.bad;
    if (ppm > Thresholds.airQuality.optimalMax) return Status.medium;
    return Status.good;
  }

  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.good:
        return AppColors.greenColor;
      case Status.bad:
        return AppColors.redColor;
      case Status.medium:
        return AppColors.secondaryColor;
    }
  }

  List<MapEntry<String, Map<String, dynamic>>> _getDataEntries() {
    return [
      MapEntry('Temperature', {
        'value': '${data.temperature?.toStringAsFixed(1)}°C',
        'status': _getTemperatureStatus(data.temperature ?? 0),
      }),
      MapEntry('Humidity', {
        'value': '${data.humidity?.toStringAsFixed(1)}%',
        'status': _getHumidityStatus(data.humidity ?? 0),
      }),
      MapEntry('Air Quality', {
        'value': '${data.gasPpm} ppm',
        'status': _getAirQualityStatus(data.gasPpm ?? 0),
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dataEntries = _getDataEntries();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ...dataEntries.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.blackColor,
                  ),
                ),
                const Spacer(),
                Text(
                  entry.value['value']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(entry.value['status']!),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

enum Status {
  good,
  medium,
  bad
}

class Thresholds {
  static const temperature = (
    min: 18.0,
    max: 35.0,
    optimalMin: 20.0,
    optimalMax: 24.0,
  );

  static const humidity = (
    min: 30.0,
    max: 70.0,
    optimalMin: 40.0,
    optimalMax: 60.0,
  );

  static const airQuality = (
    max: 1000,
    optimalMax: 800,
  );
}
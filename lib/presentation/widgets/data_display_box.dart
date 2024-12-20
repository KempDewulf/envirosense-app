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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return AppColors.greenColor;
      case 'bad':
        return AppColors.redColor;
      case 'medium':
        return AppColors.secondaryColor;
      default:
        return AppColors.blackColor;
    }
  }

  String _getTemperatureStatus(double temp) {
    if (temp < 18) return 'bad';
    if (temp > 26) return 'bad';
    if (temp < 20 || temp > 24) return 'medium';
    return 'good';
  }

  String _getHumidityStatus(double humidity) {
    if (humidity < 30) return 'bad';
    if (humidity > 70) return 'bad';
    if (humidity < 40 || humidity > 60) return 'medium';
    return 'good';
  }

  String _getAirQualityStatus(int ppm) {
    if (ppm > 1000) return 'bad';
    if (ppm > 800) return 'medium';
    return 'good';
  }

  List<MapEntry<String, Map<String, String>>> _getDataEntries() {
    return [
      MapEntry('Temperature', {
        'value': '${data.temperature.toStringAsFixed(1)}°C',
        'status': _getTemperatureStatus(data.temperature),
      }),
      MapEntry('Humidity', {
        'value': '${data.humidity.toStringAsFixed(1)}%',
        'status': _getHumidityStatus(data.humidity),
      }),
      MapEntry('Air Quality', {
        'value': '${data.gasPpm} ppm',
        'status': _getAirQualityStatus(data.gasPpm),
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
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentColor,
                  ),
                ),
                const Spacer(),
                Text(
                  entry.value['value']!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
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
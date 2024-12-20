import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../domain/entities/device_data.dart';

class DeviceDataList extends StatelessWidget {
  final List<DeviceData> deviceData;

  const DeviceDataList({super.key, required this.deviceData});

  Status _getStatus(
    num value, {
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
      case Status.medium:
        return AppColors.secondaryColor;
      case Status.bad:
        return AppColors.redColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (deviceData.isEmpty)
          const Center(
            child: Text(
              'No device data from this device.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.accentColor,
              ),
            ),
          )
        else
          ...deviceData.map(
            (data) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(
                        DateTime.parse(data.timestamp),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildDataRows(data),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildDataRows(DeviceData data) {
    return [
      _buildDataRow(
        label: 'Temperature',
        value: '${data.airData.temperature?.toStringAsFixed(1)}°C',
        status: _getTemperatureStatus(data.airData.temperature ?? 0),
        icon: Icons.thermostat,
      ),
      const SizedBox(height: 12),
      _buildDataRow(
        label: 'Humidity',
        value: '${data.airData.humidity?.toStringAsFixed(1)}%',
        status: _getHumidityStatus(data.airData.humidity ?? 0),
        icon: Icons.water_drop,
      ),
      const SizedBox(height: 12),
      _buildDataRow(
        label: 'Air Quality',
        value: '${data.airData.gasPpm} ppm',
        status: _getAirQualityStatus(data.airData.gasPpm ?? 0),
        icon: Icons.cloud,
      ),
    ];
  }

  Widget _buildDataRow({
    required String label,
    required String value,
    required Status status,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

enum Status {
  good,
  medium,
  bad,
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

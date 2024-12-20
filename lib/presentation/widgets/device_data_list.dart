import 'package:envirosense/domain/entities/device_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';

class DeviceDataList extends StatelessWidget {
  final List<DeviceData> deviceData;

  const DeviceDataList({super.key, required this.deviceData});

  Status _getStatus(double value, {required double min, required double max}) {
    if (value < min || value > max) return Status.bad;
    return Status.good;
  }

  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.good:
        return AppColors.greenColor;
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.thermostat,
                            color: AppColors.secondaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Temperature: ${data.airData.temperature}°C',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.circle,
                          color: _getStatusColor(
                            _getStatus(
                              data.airData.temperature ?? 0,
                              min: 18.0,
                              max: 24.0,
                            ),
                          ),
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.water_drop,
                            color: AppColors.secondaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Humidity: ${data.airData.humidity}%',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.circle,
                          color: _getStatusColor(
                            _getStatus(
                              data.airData.humidity ?? 0,
                              min: 40.0,
                              max: 60.0,
                            ),
                          ),
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.cloud,
                            color: AppColors.secondaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'PPM: ${data.airData.gasPpm}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.circle,
                          color: _getStatusColor(
                            _getStatus(
                              data.airData.gasPpm?.toDouble() ?? 0,
                              min: 0,
                              max: 800,
                            ),
                          ),
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum Status {
  good,
  bad,
}

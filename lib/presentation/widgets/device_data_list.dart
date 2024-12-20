import 'package:envirosense/domain/entities/device_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';

class DeviceDataList extends StatelessWidget {
  final List<DeviceData> deviceData;

  const DeviceDataList({super.key, required this.deviceData});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),
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
            (deviceData) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.parse(deviceData.timestamp)),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.thermostat,
                            color: AppColors.secondaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Temperature: ${deviceData.airData.temperature}°C',
                          style: const TextStyle(fontSize: 16),
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
                          'Humidity: ${deviceData.airData.humidity}%',
                          style: const TextStyle(fontSize: 16),
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
                          'PPM: ${deviceData.airData.gasPpm}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}

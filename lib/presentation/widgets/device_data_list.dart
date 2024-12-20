import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../domain/entities/device_data.dart';
import '../../../core/helpers/data_status_helper.dart';

class DeviceDataList extends StatelessWidget {
  final List<DeviceData> deviceData;

  const DeviceDataList({super.key, required this.deviceData});

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
        status:
            DataStatusHelper.getTemperatureStatus(data.airData.temperature ?? 0),
        icon: Icons.thermostat,
      ),
      const SizedBox(height: 12),
      _buildDataRow(
        label: 'Humidity',
        value: '${data.airData.humidity?.toStringAsFixed(1)}%',
        status: DataStatusHelper.getHumidityStatus(data.airData.humidity ?? 0),
        icon: Icons.water_drop,
      ),
      const SizedBox(height: 12),
      _buildDataRow(
        label: 'Air Quality',
        value: '${data.airData.gasPpm} ppm',
        status: DataStatusHelper.getAirQualityStatus(data.airData.gasPpm ?? 0),
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
            color: DataStatusHelper.getStatusColor(status),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

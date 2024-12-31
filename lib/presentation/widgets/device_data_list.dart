import 'package:envirosense/core/enums/status.dart';
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
            (data) => Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 211, 211, 211),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd-MM-yyyy HH:mm:ss').format(
                        DateTime.parse(data.timestamp),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.accentColor,
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
        status: DataStatusHelper.getTemperatureStatus(
            data.airData.temperature ?? 0),
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
        label: 'CO2 Level',
        value: '${data.airData.ppm} ppm',
        status: DataStatusHelper.getPPMStatus(data.airData.ppm ?? 0),
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
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: DataStatusHelper.getStatusColor(status),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:envirosense/domain/entities/device_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/enums/status.dart';
import '../../../core/helpers/data_status_helper.dart';

class DeviceDataCard extends StatefulWidget {
  final DeviceData data;
  final bool isNewest;

  const DeviceDataCard({
    super.key,
    required this.data,
    required this.isNewest,
  });

  @override
  State<DeviceDataCard> createState() => _DeviceDataCardState();
}

class _DeviceDataCardState extends State<DeviceDataCard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.0),
        border: widget.isNewest
            ? Border.all(
                color: AppColors.secondaryColor,
                width: 2.0,
              )
            : null,
        boxShadow: widget.isNewest
            ? [
                BoxShadow(
                  color: AppColors.secondaryColor.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                const BoxShadow(
                  color: Color.fromARGB(255, 211, 211, 211),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd-MM-yyyy HH:mm:ss').format(
                    DateTime.parse(widget.data.timestamp).toLocal(),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.accentColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDataRow(
                  label: 'Temperature',
                  value:
                      '${widget.data.airData.temperature?.toStringAsFixed(1)}°C',
                  status: DataStatusHelper.getTemperatureStatus(
                    widget.data.airData.temperature ?? 0,
                  ),
                  icon: Icons.thermostat,
                ),
                const SizedBox(height: 12),
                _buildDataRow(
                  label: 'Humidity',
                  value: '${widget.data.airData.humidity?.toStringAsFixed(1)}%',
                  status: DataStatusHelper.getHumidityStatus(
                    widget.data.airData.humidity ?? 0,
                  ),
                  icon: Icons.water_drop,
                ),
                const SizedBox(height: 12),
                _buildDataRow(
                  label: 'CO2 Level',
                  value: '${widget.data.airData.ppm?.toStringAsFixed(0)} ppm',
                  status: DataStatusHelper.getPPMStatus(
                    widget.data.airData.ppm ?? 0,
                  ),
                  icon: Icons.co2,
                ),
              ],
            ),
          ),
          if (widget.isNewest)
            Positioned(
              top: 12,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Most Recent',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

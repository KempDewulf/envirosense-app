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
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.2, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: widget.isNewest
                ? [
                    BoxShadow(
                      color: AppColors.secondaryColor
                          .withOpacity(_animation.value),
                      spreadRadius: 2,
                      blurRadius: 15,
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
          child: Padding(
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
                  label: 'CO2',
                  value: '${widget.data.airData.ppm?.toStringAsFixed(0)} ppm',
                  status: DataStatusHelper.getPPMStatus(
                    widget.data.airData.ppm ?? 0,
                  ),
                  icon: Icons.co2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

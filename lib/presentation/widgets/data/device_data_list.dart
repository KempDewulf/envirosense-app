import 'package:envirosense/core/enums/status.dart';
import 'package:envirosense/presentation/widgets/actions/pagination_controls.dart';
import 'package:envirosense/presentation/widgets/cards/device_data_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../domain/entities/device_data.dart';
import '../../../../core/helpers/data_status_helper.dart';

class DeviceDataList extends StatefulWidget {
  final List<DeviceData> deviceData;
  final Future<void> Function() onRefresh;

  const DeviceDataList({
    super.key,
    required this.deviceData,
    required this.onRefresh,
  });

  @override
  State<DeviceDataList> createState() => _DeviceDataListState();
}

class _DeviceDataListState extends State<DeviceDataList> {
  static const int itemsPerPage = 6;
  int currentPage = 1;

  int get totalPages => (widget.deviceData.length / itemsPerPage).ceil();

  List<DeviceData> get currentPageItems {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return widget.deviceData.sublist(
      startIndex,
      endIndex > widget.deviceData.length ? widget.deviceData.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: AppColors.secondaryColor,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (widget.deviceData.isEmpty)
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
                  ...currentPageItems.map(
                    (data) => DeviceDataCard(
                      data: data,
                      isNewest: widget.deviceData.first == data,
                    ),
                  ),
              ],
            ),
          ),
          if (widget.deviceData.isNotEmpty)
            PaginationControls(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: (page) => setState(() => currentPage = page),
            ),
        ],
      ),
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

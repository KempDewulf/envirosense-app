import 'package:envirosense/core/enums/status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../domain/entities/device_data.dart';
import '../../../core/helpers/data_status_helper.dart';

class DeviceDataList extends StatefulWidget {
  final List<DeviceData> deviceData;

  const DeviceDataList({super.key, required this.deviceData});

  @override
  _DeviceDataListState createState() => _DeviceDataListState();
}

class _DeviceDataListState extends State<DeviceDataList> {
  String _currentDate = '';

  @override
  void initState() {
    super.initState();
    if (widget.deviceData.isNotEmpty) {
      _currentDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(widget.deviceData.first.timestamp));
    }
  }

  void _updateCurrentDate(String date) {
    setState(() {
      _currentDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<DeviceData>> groupedData = {};

    for (var data in widget.deviceData) {
      final date =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(data.timestamp));
      if (groupedData[date] == null) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(data);
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          expandedHeight: 50.0,
          backgroundColor: AppColors.accentColor,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            title: Text(
              _currentDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            groupedData.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification) {
                        final context = scrollNotification.context;
                        final renderBox =
                            context?.findRenderObject() as RenderBox;
                        final offset = renderBox.localToGlobal(Offset.zero).dy;
                        if (offset < 100) {
                          _updateCurrentDate(entry.key);
                        }
                      }
                      return true;
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        ...entry.value.map((data) => Card(
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
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time,
                                            color: AppColors.accentColor),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('HH:mm:ss').format(
                                              DateTime.parse(data.timestamp)),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.accentColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    ..._buildDataRows(data),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
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

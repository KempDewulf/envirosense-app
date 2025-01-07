import 'package:envirosense/core/helpers/unit_helper.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../domain/entities/air_data.dart';
import '../../../../core/helpers/data_status_helper.dart';

class DataDisplayBox extends StatelessWidget {
  final String title;
  final AirData data;

  const DataDisplayBox({
    super.key,
    required this.title,
    required this.data,
  });

  Future<List<MapEntry<String, Map<String, dynamic>>>> _getDataEntries() async {
    final temp = await UnitConverter.formatTemperature(data.temperature);

    return [
      MapEntry('Temperature', {
        'value': temp,
        'status': DataStatusHelper.getTemperatureStatus(data.temperature ?? 0),
      }),
      MapEntry('Humidity', {
        'value': '${data.humidity?.toStringAsFixed(1)}%',
        'status': DataStatusHelper.getHumidityStatus(data.humidity ?? 0),
      }),
      MapEntry('CO2 Level', {
        'value': '${data.ppm} ppm',
        'status': DataStatusHelper.getPPMStatus(data.ppm ?? 0),
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<List<MapEntry<String, Map<String, dynamic>>>>(
        future: _getDataEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return const Text('No data available');
          }

          return Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ...snapshot.data!.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        entry.value['value'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: DataStatusHelper.getStatusColor(entry.value['status']),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

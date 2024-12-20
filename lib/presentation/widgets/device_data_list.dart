import 'package:envirosense/domain/entities/device_data.dart';
import 'package:flutter/material.dart';
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
          ...deviceData.map((deviceData) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_graph_rounded,
                          color: AppColors.secondaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deviceData.timestamp,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                deviceData.airData.temperature.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                deviceData.airData.humidity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                deviceData.airData.gasPpm.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
      ],
    );
  }
}

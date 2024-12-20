import 'package:envirosense/core/helpers/device_storage_helper.dart';
import 'package:envirosense/domain/entities/device.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class DevicesList extends StatelessWidget {
  final DeviceStorageHelper _deviceStorageHelper = DeviceStorageHelper();
  final List<Device> devices;

  DevicesList({super.key, required this.devices});

  void _navigateToDeviceDetail(BuildContext context, Device device) {
    Navigator.pushNamed(context, '/deviceOverview', arguments: {
      'deviceName': device.identifier,
      'deviceId': device.id,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),
        if (devices.isEmpty)
          const Center(
            child: Text(
              'No devices in this room',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.accentColor,
              ),
            ),
          )
        else
          ...devices.map((device) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => _navigateToDeviceDetail(context, device),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sensors,
                          color: AppColors.secondaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<String?>(
                                future: _deviceStorageHelper
                                    .getDeviceName(device.identifier),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Loading...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                      'Error',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      snapshot.data ?? device.identifier,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.secondaryColor,
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

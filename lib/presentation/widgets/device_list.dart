import 'package:envirosense/domain/entities/device.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class DevicesList extends StatelessWidget {
  final List<Device> devices;

  const DevicesList({super.key, required this.devices});

  void _navigateToDeviceDetail(BuildContext context, Device device) {
    // TODO: Implement navigation to device detail screen
    // Navigator.pushNamed(context, '/deviceDetail', arguments: device);
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
                              Text(
                                device.identifier,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
              ))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:envirosense/domain/entities/device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;

  const DeviceCard({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sensors,
              color: Colors.blue,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              device.name,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            // Additional device details can be added here
          ],
        ),
      ),
    );
  }
}
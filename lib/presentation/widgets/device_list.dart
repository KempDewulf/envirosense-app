import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'device_card.dart';
import '../../../domain/entities/device.dart';

class DevicesList extends StatelessWidget {
  final String roomId;

  const DevicesList({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text(
          'Devices in Room',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        SizedBox(height: 16),
        // TODO: Fetch and display devices for this room
      ],
    );
  }
}
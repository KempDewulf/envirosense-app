import 'dart:convert';

import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/domain/entities/device.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceCard extends StatefulWidget {
  final Device device;

  const DeviceCard({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  String? _customDeviceName;

  @override
  void initState() {
    super.initState();
    _fetchDeviceName();
  }

  @override
  void didUpdateWidget(DeviceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.device.identifier != widget.device.identifier) {
      _fetchDeviceName();
    }
  }

  Future<void> _fetchDeviceName() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedMappings = prefs.getString('device_names');
    if (storedMappings != null) {
      final Map<String, dynamic> deviceMappings =
          Map<String, dynamic>.from(json.decode(storedMappings));

      setState(() {
        _customDeviceName = deviceMappings[widget.device.identifier] as String?;
      });
    } else {
      setState(() {
        _customDeviceName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(widget.device.identifier), // Ensure unique key
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.sensors,
              color: AppColors.secondaryColor,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              _customDeviceName ?? widget.device.identifier,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Room: ${widget.device.room?.name ?? 'Unknown'}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

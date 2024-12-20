import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/core/helpers/device_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/domain/entities/device.dart';

class DeviceCard extends StatefulWidget {
  final Device device;

  const DeviceCard({
    super.key,
    required this.device,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  String? _customDeviceName;
  final DeviceStorageHelper _deviceStorageHelper = DeviceStorageHelper();

  @override
  void initState() {
    super.initState();
    _loadDeviceName();
  }

  @override
  void didUpdateWidget(DeviceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.device.identifier != widget.device.identifier) {
      _loadDeviceName();
    }
  }

  Future<void> _loadDeviceName() async {
    final name =
        await _deviceStorageHelper.getDeviceName(widget.device.identifier);
    setState(() {
      _customDeviceName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/deviceOverview',
          arguments: {
            'deviceName': _customDeviceName ?? widget.device.identifier,
            'deviceId': widget.device.id,
          },
        );
      },
      child: Card(
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
                widget.device.room?.name ?? 'Unknown room',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

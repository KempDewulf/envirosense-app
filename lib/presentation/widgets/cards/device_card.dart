import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/domain/entities/device.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final VoidCallback? onChanged;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onChanged,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  String? _customDeviceName;
  final DatabaseService _databaseService = DatabaseService();

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
    final name = await _databaseService.getDeviceName(widget.device.identifier);
    setState(() {
      _customDeviceName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/deviceOverview',
          arguments: {
            'deviceName': _customDeviceName ?? widget.device.identifier,
            'deviceId': widget.device.id,
          },
        ).then((value) {
          if (value == true) {
            widget.onChanged?.call();
            _loadDeviceName();
          }
        });
      },
      child: Container(
        key: ValueKey(widget.device.identifier), // Ensure unique key
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
                  color: AppColors.blackColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.device.room?.name ?? l10n.notAssigned,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.accentColor,
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

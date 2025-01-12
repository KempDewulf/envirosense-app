import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';

class DevicesList extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();
  final List<Device> devices;

  DevicesList({super.key, required this.devices});

  void _navigateToDeviceDetail(BuildContext context, Device device) async {
    Navigator.pushNamed(context, '/deviceOverview', arguments: {
      'deviceName': await _databaseService.getDeviceName(device.identifier),
      'deviceId': device.id,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),
        if (devices.isEmpty)
          Center(
            child: Text(
              l10n.noDevicesInRoom,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.accentColor,
              ),
            ),
          )
        else
          ...devices.map((device) => Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
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
                                future: _databaseService.getDeviceName(device.identifier),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text(
                                      l10n.loadingDeviceName,
                                      style: TextStyle(fontSize: 16, color: AppColors.accentColor),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      l10n.error,
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

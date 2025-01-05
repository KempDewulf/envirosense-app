import 'package:envirosense/presentation/widgets/data/data_display_box.dart';
import 'package:envirosense/presentation/widgets/cards/enviro_score_card.dart';
import 'package:envirosense/presentation/widgets/data/environment_data_toggle.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../domain/entities/air_data.dart';
import '../../../domain/entities/room_air_quality.dart';

class RoomOverviewContent extends StatelessWidget {
  final RoomAirQuality? airQuality;
  final bool roomHasDeviceData;
  final double targetTemperature;
  final VoidCallback onSetTemperature;
  final bool showRoomData;
  final Function(bool) onDataToggle;
  final AirData? outsideAirData;

  const RoomOverviewContent({
    super.key,
    required this.airQuality,
    required this.roomHasDeviceData,
    required this.targetTemperature,
    required this.onSetTemperature,
    required this.showRoomData,
    required this.onDataToggle,
    required this.outsideAirData,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        EnviroScoreCard(
          score: airQuality?.enviroScore ?? 0,
          isDataAvailable: roomHasDeviceData,
          type: 'Room',
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onSetTemperature,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.thermostat, color: AppColors.secondaryColor),
              const SizedBox(width: 8),
              Text(
                'Set Target Temperature ($targetTemperature°C)',
                style:
                    const TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              EnvironmentDataToggle(
                showRoomData: showRoomData,
                roomHasDeviceData: roomHasDeviceData,
                onToggle: onDataToggle,
              ),
              const SizedBox(height: 32),
              DataDisplayBox(
                key: ValueKey(showRoomData),
                title:
                    showRoomData ? 'Room Environment' : 'Outside Environment',
                data: showRoomData && roomHasDeviceData
                    ? airQuality?.airData ??
                        AirData(temperature: 0, humidity: 0, ppm: 0)
                    : outsideAirData!,
              )
            ],
          ),
        ),
      ],
    );
  }
}

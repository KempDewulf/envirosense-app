import 'package:envirosense/presentation/widgets/cards/enviro_score_card.dart';
import 'package:envirosense/presentation/widgets/data/environment_data_section.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../domain/entities/air_data.dart';
import '../../../domain/entities/room_air_quality.dart';

class RoomOverviewContent extends StatelessWidget {
  final RoomAirQuality? airQuality;
  final bool roomHasDeviceData;
  final double? targetTemperature;
  final bool showRoomData;
  final AirData? outsideAirData;
  final VoidCallback onSetTemperature;
  final Function(bool) onDataToggle;

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
          onPressed: targetTemperature == null ? null : onSetTemperature,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey[300]!;
              }
              return AppColors.primaryColor;
            }),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 18),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.thermostat,
                  color: targetTemperature == null
                      ? Colors.grey[600]
                      : AppColors.secondaryColor),
              const SizedBox(width: 8),
              Text(
                targetTemperature == null
                    ? 'Not Available'
                    : 'Set Target Temperature ($targetTemperature°C)',
                style: TextStyle(
                    color: targetTemperature == null
                        ? Colors.grey[600]
                        : AppColors.whiteColor,
                    fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              EnvironmentDataSection(
                  showRoomData: showRoomData,
                  roomHasDeviceData: roomHasDeviceData,
                  onToggleData: onDataToggle,
                  roomData: airQuality?.airData ??
                      AirData(temperature: 0, humidity: 0, ppm: 0),
                  outsideData: outsideAirData!),
            ],
          ),
        ),
      ],
    );
  }
}

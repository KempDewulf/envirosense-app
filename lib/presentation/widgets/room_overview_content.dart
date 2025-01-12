import 'package:envirosense/presentation/widgets/actions/target_temperature_button.dart';
import 'package:envirosense/presentation/widgets/cards/enviro_score_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/presentation/widgets/data/environment_data_section.dart';
import 'package:flutter/material.dart';
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

  final bool isLoadingTemperature;

  const RoomOverviewContent({
    super.key,
    required this.airQuality,
    required this.roomHasDeviceData,
    required this.targetTemperature,
    required this.onSetTemperature,
    required this.showRoomData,
    required this.onDataToggle,
    required this.outsideAirData,
    required this.isLoadingTemperature,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        EnviroScoreCard(
          score: airQuality?.enviroScore ?? 0,
          isDataAvailable: roomHasDeviceData,
          type: l10n.room,
        ),
        const SizedBox(height: 24),
        TargetTemperatureButton(
          targetTemperature: targetTemperature,
          isLoadingTemperature: isLoadingTemperature,
          onSetTemperature: onSetTemperature,
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
                  roomData: airQuality?.airData ?? AirData(temperature: 0, humidity: 0, ppm: 0),
                  outsideData: outsideAirData!),
            ],
          ),
        ),
      ],
    );
  }
}

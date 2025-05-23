import 'package:envirosense/core/helpers/unit_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/core/constants/colors.dart';

class TargetTemperatureSheet extends StatelessWidget {
  final double? currentTemperature;
  final Function(double) onTemperatureChanged;

  const TargetTemperatureSheet({
    super.key,
    required this.currentTemperature,
    required this.onTemperatureChanged,
  });

  double roundToNearestHalf(double value) {
    double rounded = (value * 2).round() / 2;
    return double.parse(rounded.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context)!;
    double? tempValue = currentTemperature;

    return StatefulBuilder(
      builder: (context, setState) {
        void incrementTemp() async {
          final useImperial = await UnitConverter.getUseImperialUnits();
          setState(() {
            if (useImperial) {
              final fahrenheit = UnitConverter.celsiusToFahrenheit(tempValue!);
              final newFahrenheit = fahrenheit.round() + 1;
              tempValue = ((newFahrenheit - 32) * 5 / 9).clamp(0, 80);
            } else {
              tempValue = roundToNearestHalf((tempValue! + 0.5).clamp(0, 80));
            }
          });
        }

        void decrementTemp() async {
          final useImperial = await UnitConverter.getUseImperialUnits();
          setState(() {
            if (useImperial) {
              final fahrenheit = UnitConverter.celsiusToFahrenheit(tempValue!);
              final newFahrenheit = fahrenheit.round() - 1;
              tempValue = ((newFahrenheit - 32) * 5 / 9).clamp(0, 80);
            } else {
              tempValue = roundToNearestHalf((tempValue! - 0.5).clamp(0, 80));
            }
          });
        }

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.targetTemperature,
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          iconSize: 28,
                          color: AppColors.secondaryColor,
                          onPressed: () => decrementTemp(),
                        ),
                        const SizedBox(width: 16),
                        FutureBuilder<String>(
                          future: UnitConverter.getUseImperialUnits().then((useImperial) {
                            if (useImperial) {
                              return UnitConverter.formatDisplayTemperature(tempValue);
                            } else {
                              return UnitConverter.formatTemperature(tempValue);
                            }
                          }),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? l10n.loading,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: 28,
                          color: AppColors.secondaryColor,
                          onPressed: () => incrementTemp(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 180,
                      child: FilledButton(
                        onPressed: () {
                          final roundedTemp = roundToNearestHalf(tempValue!);
                          onTemperatureChanged(roundedTemp);
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.save,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

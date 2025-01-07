import 'package:envirosense/core/helpers/unit_helper.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class TargetTemperatureButton extends StatelessWidget {
  final double? targetTemperature;
  final bool isLoadingTemperature;
  final VoidCallback? onSetTemperature;

  const TargetTemperatureButton({
    super.key,
    required this.targetTemperature,
    required this.isLoadingTemperature,
    required this.onSetTemperature,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoadingTemperature || targetTemperature == null ? null : onSetTemperature,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightGrayColor;
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
          if (isLoadingTemperature)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),
              ),
            )
          else
            Icon(
              Icons.thermostat_outlined,
              color: targetTemperature == null ? AppColors.accentColor : AppColors.secondaryColor,
            ),
          const SizedBox(width: 8),
          if (isLoadingTemperature)
            const Text(
              'Loading Temperature Limit',
              style: TextStyle(color: AppColors.accentColor, fontSize: 16),
            )
          else
            FutureBuilder<String>(
              future: targetTemperature != null
                  ? UnitConverter.formatButtonTemperature(targetTemperature).then((temp) => 'Set Target Temperature ($temp)')
                  : Future.value('Temperature Limit Not Available'),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? 'Loading...',
                  style: TextStyle(color: targetTemperature == null ? AppColors.accentColor : AppColors.whiteColor, fontSize: 16),
                );
              },
            ),
        ],
      ),
    );
  }
}

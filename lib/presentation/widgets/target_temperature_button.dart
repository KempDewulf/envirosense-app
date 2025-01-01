import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class TargetTemperatureButton extends StatelessWidget {
  final double temperature;
  final VoidCallback onPressed;

  const TargetTemperatureButton({
    super.key,
    required this.temperature,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
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
            'Set Target Temperature ($temperature°C)',
            style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

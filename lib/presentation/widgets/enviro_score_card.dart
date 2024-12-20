import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class EnviroScoreCard extends StatelessWidget {
  final int score;
  final VoidCallback onInfoPressed;
  final bool isDeviceDataAvailable;

  const EnviroScoreCard({
    super.key,
    required this.score,
    required this.onInfoPressed,
    required this.isDeviceDataAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Room EnviroScore',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: onInfoPressed,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: isDeviceDataAvailable
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  isDeviceDataAvailable ? '$score' : 'No data available',
                  style: TextStyle(
                    fontSize: isDeviceDataAvailable ? 48 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  isDeviceDataAvailable ? '%' : '',
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
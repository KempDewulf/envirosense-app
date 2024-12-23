import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class EnviroScoreCard extends StatelessWidget {
  final double score;
  final VoidCallback onInfoPressed;
  final bool isDeviceDataAvailable;
  final String type;

  const EnviroScoreCard({
    super.key,
    required this.score,
    required this.onInfoPressed,
    required this.isDeviceDataAvailable,
    this.type = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 211, 211, 211),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                type.isNotEmpty
                    ? Text(
                        '$type EnviroScore',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        'EnviroScore',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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

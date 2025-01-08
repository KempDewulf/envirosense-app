import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class EnviroScoreCard extends StatelessWidget {
  final double score;
  final bool isDataAvailable;
  final String type;

  const EnviroScoreCard({
    super.key,
    required this.score,
    required this.isDataAvailable,
    this.type = '',
  });

  @override
  Widget build(BuildContext context) {
    void showEnviroScoreInfo() {
      showDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: true,
        routeSettings: const RouteSettings(),
        builder: (context) => AlertDialog(
          title: const Text(
            'About EnviroScore',
            style: TextStyle(color: AppColors.secondaryColor),
          ),
          content: const Text(
            'EnviroScore is a measure of environmental quality based on various factors including air quality, temperature, and humidity levels in your space.',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
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
                  onPressed: showEnviroScoreInfo,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  isDataAvailable ? '$score' : 'No data available',
                  style: TextStyle(
                    fontSize: isDataAvailable ? 48 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  isDataAvailable ? '%' : '',
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

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
        builder: (context) => AlertDialog(
          title: const Text('About EnviroScore'),
          content: const Text(
            'EnviroScore is a measure of environmental quality based on various factors including air quality, temperature, and humidity levels in your space.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
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

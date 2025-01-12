import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    void showEnviroScoreInfo() {
      showDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: true,
        routeSettings: const RouteSettings(),
        builder: (context) => AlertDialog(
          title: Text(
            l10n.enviroScoreAboutTitle,
            style: TextStyle(color: AppColors.secondaryColor),
          ),
          content: Text(
            l10n.enviroScoreDescription,
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
              child: Text(
                l10n.gotIt,
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
                        l10n.typedEnviroScore(type),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        l10n.enviroScore,
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
                  isDataAvailable ? '$score' : l10n.noDataAvailable,
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

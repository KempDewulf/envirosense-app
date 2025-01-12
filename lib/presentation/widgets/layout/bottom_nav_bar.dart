import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.secondaryColor,
      unselectedItemColor: AppColors.accentColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: l10n.navHome
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: l10n.navStatistics,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: l10n.settings,
        ),
      ],
    );
  }
}

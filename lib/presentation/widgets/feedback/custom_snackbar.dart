import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class CustomSnackbar {
  static void showSnackBar(BuildContext context, String message) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetSnackBar(context);
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.secondaryColor,
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _showNoInternetSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.wifi_off, color: AppColors.whiteColor),
            const SizedBox(width: 8),
            const Text('No internet connection'),
          ],
        ),
        backgroundColor: AppColors.redColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Retry',
          textColor: AppColors.whiteColor,
          onPressed: () => showSnackBar(context, 'Checking connection...'),
        ),
      ),
    );
  }
}

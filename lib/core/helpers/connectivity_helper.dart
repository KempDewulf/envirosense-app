import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityHelper {
  static Future<bool> checkConnectivity(
    BuildContext context, {
    required Function(String) setError,
    required Function(bool) setLoading,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setError('no_connection');
      setLoading(false);
      return false;
    }

    return true;
  }
}

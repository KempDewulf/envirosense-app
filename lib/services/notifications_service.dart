import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late final NotificationSettings settings;
  late final String? token;

  Future<void> init() async {
    try {
      // Request permission without timeout
      settings = await _fcm.requestPermission();

      // Only get token if permission was granted
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        token = await _fcm.getToken();
      }
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }
}

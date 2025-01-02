

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late final NotificationSettings settings;
  late final String? token;

  Future<void> init() async {
    settings = await _fcm.requestPermission();
    token = await _fcm.getToken();
  }
}
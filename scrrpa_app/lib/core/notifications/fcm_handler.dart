import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FCMHandler {
  static Future<void> initialize(BuildContext context, ApiService apiService) async {
    final messaging = FirebaseMessaging.instance;

    // 1. Request permissions (iOS/Android)
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // 2. Get and register token
    final token = await messaging.getToken();
    if (token != null) {
      await apiService.post('/users/fcm-token', data: {'token': token});
    }

    // 3. Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) {
      apiService.post('/users/fcm-token', data: {'token': newToken});
    });

    // 4. Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (!context.mounted) return;
      _showInAppNotification(context, message);
    });

    // 5. Handle background/terminated state click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (!context.mounted) return;
      _handleDeepLink(context, message);
    });
  }

  static void _showInAppNotification(BuildContext context, RemoteMessage message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.notification?.title ?? "Notification", 
                 style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(message.notification?.body ?? ""),
          ],
        ),
        action: SnackBarAction(
          label: "View",
          onPressed: () => _handleDeepLink(context, message),
        ),
      ),
    );
  }

  static void _handleDeepLink(BuildContext context, RemoteMessage message) {
    final route = message.data['action_route'];
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }
}

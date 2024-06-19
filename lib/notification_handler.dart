// Checking FMS with example
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationHandler {

  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showNotification( RemoteMessage message,GlobalKey<ScaffoldMessengerState>key) {
    final notification = message.notification;
    final title = notification!.title;
    final body = notification.body;
    // Show the notification
    key.currentState!.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(body!),
          ],
        ),
      ),
    );
  }
}

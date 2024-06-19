// checking FMS with example
import 'package:driverapp/notification_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
      // Save the token to your server or database
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notification received: ${message.notification?.title}');
      NotificationHandler.showNotification(message, scaffoldMessengerKey);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification launched: ${message.notification?.title}');
      NotificationHandler.showNotification(message, scaffoldMessengerKey);
    });
  }
}
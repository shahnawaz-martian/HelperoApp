import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:helpero/feature/bookings/view/booking_details.dart';

import '../main.dart';

// BACKGROUND HANDLER
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔵 Background Message: ${message.data}");
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Local Notifications
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        print("🔵 Local Notification Clicked: ${response.payload}");
        handleMessageClick({"bookingId": response.payload});
      },
    );

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🟢 Foreground Message: ${message.data}");

      // String? bookingId = message.data["bookingId"];
      String? bookingId = "3eaae190-6583-4391-920c-6a9042118e5d";

      // Show local notification for user
      showLocalNotification(
        title: message.notification?.title ?? "New Update",
        body: message.notification?.body ?? "",
        payload: bookingId, // PASS bookingId
      );
    });

    // Background Message
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🟠 Message Tap (Background): ${message.data}");
      handleMessageClick(message.data);
    });
  }

  //  NOTIFICATION PERMISSION
  static Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🔔 Permission: ${settings.authorizationStatus}");
  }

  // SHOW LOCAL NOTIFICATION
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await localNotifications.show(0, title, body, platformDetails);
  }

  // HANDLE NOTIFICATION CLICK
  static void handleMessageClick(Map<String, dynamic>? data) {
    if (data == null) return;

    // String? bookingId = data["bookingId"];
    String? bookingId = "3eaae190-6583-4391-920c-6a9042118e5d";

    if (bookingId == null || bookingId.isEmpty) {
      print("⚠ No bookingId found in notification.");
      return;
    }

    print("➡ Navigating to Booking Screen with ID: $bookingId");

    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => BookingDetails(bookingId: bookingId)),
    );
  }

  static Future<String> getDeviceToken() async {
    final messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token!;
  }

  static Future<void> isTokenRefresh() async {
    final messaging = FirebaseMessaging.instance;
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}

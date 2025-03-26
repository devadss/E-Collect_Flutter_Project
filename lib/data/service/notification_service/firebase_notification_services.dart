import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServiceQrCode {
  static final NotificationServiceQrCode _instance = NotificationServiceQrCode._internal();

  factory NotificationServiceQrCode() {
    return _instance;
  }

  NotificationServiceQrCode._internal();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Initialize Firebase Messaging and Local Notifications
  Future<void> initialize() async {
    // Initialize Firebase Messaging
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

    // Initialize Flutter Local Notifications Plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _initializeLocalNotifications();
  }

  // Initialize the local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Replace with your app icon

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }


  // Handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    if (message.notification?.body?.toLowerCase().contains('your payment has been successfully processed') ?? false) {
      //Trigger the event (e.g., notify user)
      //   showNotification(message.notification?.title, message.notification?.body);
    } else {
      // showNotification(message.notification?.title, message.notification?.body);
    }
  }

  // Handle foreground messages
  void _firebaseMessagingForegroundHandler(RemoteMessage message) {
    print("Message received in foreground: ${message.notification?.title}");
    if (message.notification?.body?.toLowerCase().contains('your payment has been successfully processed') ?? false) {
      // Trigger the event (e.g., notify user)
      showNotification(message.notification?.title, message.notification?.body);
    } else {
      showNotification(message.notification?.title, message.notification?.body);
    }
  }

  // Show notification to the user
  void showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'fcm_default_channel',
      'FCM Notifications',
      channelDescription: 'Channel for FCM notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'), // Your sound file here
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'Notification payload',
    );
  }
}
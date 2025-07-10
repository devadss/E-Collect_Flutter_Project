
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../core/constants.dart';
import '../../../presentation/app/bottom_nav_bar_page.dart';
import '../../storage/shared_pref_helper.dart';
import '../../../presentation/auth/authetication_page/google_pin_code_page.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize(VoidCallback onSuccessfulPayment) async {
    print("Notification service initialized.");
    // Initialize Flutter Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS, // Add iOS-specific settings
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle when the user taps on a notification
        onSuccessfulPayment(); // Call the callback for successful payment
      },
    );

    // Request permission for notifications (iOS 10+)
    await _firebaseMessaging.requestPermission();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(
          message.notification!.title,
          message.notification!.body,
        );
        print("NotificationService ${message.notification!.body}");
        // Check for successful payment message
        if (message.notification!.body
            ?.toLowerCase()
            .contains("your payment has been successfully processed") ==
            true) {
          onSuccessfulPayment(); // Call the passed method
          //  Navigator.of(context).pop(); // Navigate back to the previous page
        }
      }
    });

    // Handle background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (message.notification!.body
            ?.toLowerCase()
            .contains("your payment has been successfully processed") ==
            true) {
          onSuccessfulPayment(); // Call the passed method
          //  Navigator.of(context).pop(); // Navigate back to the previous page
        }
      }
    });
  }

  static Future<void> _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'fcm_default_channel',
      'Notifications',
      channelDescription: 'Default channel for app notifications',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static Future<void> handleNewToken() async {
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");
    // Send this token to your backend for user identification
  }

  bool isAuthenticated = false;

  Future<void> addFcmToken(String token,
     // String entityID,
      String agentID,
      BuildContext context,
      String navPage, String appToken, String mobnum, String mpin) async {
    //final url = Uri.parse('${baseUrl}api/RegisterToken');
    final url = Uri.parse('${baseUrl}api/AgentRegisterToken');

    final body = {
      "agentId": agentID,
      "mobileNumber": mobnum,
      "deviceToken": token.trim().toString()

    };
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('addFcmToken body = $body');
    print('addFcmToken response = ${response.body}');
    print('statusCode: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('stnavPageatusCode: $navPage');
      if (navPage == 'GPIN') {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            const GooglePinCodePage()));

      }
    }
  }
}
bool _isRequestingPermission = false;



Future<String?> fetchFcmTokenWithRetries({int maxRetries = 3}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        return token;
      }
    } catch (e) {
      print('Attempt $attempt: Error fetching FCM token: $e');
      log('Attempt $attempt: Error fetching FCM token: $e');
    }
    await Future.delayed(
        const Duration(seconds: 2)); // Small delay before retrying
  }
  return null; // Return null after exhausting retries
}

Future<void> saveFcmToken(
    String entityID, BuildContext context,
    String navPage, String tok, String mob, String mpin) async
{
  if (_isRequestingPermission) {
    print("Permission request is already in progress.");
    return; // Exit if a request is already in progress
  }

  _isRequestingPermission = true; // Set the flag to true

  try {
    await FirebaseMessaging.instance.requestPermission();

    final fcmToken = await fetchFcmTokenWithRetries(); // Retry mechanism
    if (fcmToken != null) {
      // Adding a timeout for the server call
      await Future.any([
        NotificationService().addFcmToken(fcmToken,
            entityID, context, navPage, tok , mob, mpin),
        Future.delayed(const Duration(seconds: 5),
                () => throw TimeoutException("Server call timed out"))
      ]);
      print('FCM token saved successfully');
      log('FCM token saved successfully');
       SharedPref.shared.setFcmToken(fcmToken);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavScreen()),
            (route) => false,
      );
    } else {
      print('Failed to fetch FCM token after retries');
      log('Failed to fetch FCM token after retries');
    }
  } catch (e, stacktrace) {
    print('Error in saving FCM token: $e');
    log('Error in saving FCM token: $e');
    log('Stacktrace: $stacktrace');
  } finally {
    _isRequestingPermission = false; // Reset the flag
  }
}

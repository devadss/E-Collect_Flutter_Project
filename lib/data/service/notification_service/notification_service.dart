
import 'dart:async';
import 'dart:convert';
import 'package:e_Collect/core/constants.dart';
import 'package:e_Collect/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../presentation/merchant/bottom_nav/bottom_nav_bar.dart';
import '../../storage/shared_pref_helper.dart';
import '../../../presentation/auth/authetication_page/google_pin_code_page.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize(VoidCallback onSuccessfulPayment) async {
    if(printStatementStatus){
      print("Notification service initialized.");
    }

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
        if(printStatementStatus){
          print("NotificationService ${message.notification!.body}");
        }

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

  Future<void> addFcmToken(
      String token,
      String bToken,
      String agentID,
      BuildContext context,
      String navPage,
      String mobnum) async {
   // final url = Uri.parse('${baseUrl}api/AgentRegisterToken');
      final url = Uri.parse('${eCollectBaseUrl}api/device/register');

    final body = {
      "customerId": agentID,
      "mobileNumber": mobnum,
      "deviceType":"Android",
      "appVersion":"22.0.1",
      "deviceToken": token.trim().toString()
    };
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $bToken',
        'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
if(printStatementStatus){
  print('agentID = $agentID');
  print('mobnum = $mobnum');
  print('bToken = $bToken');
  print('addFcmToken body = $body');
  print('addFcmToken response = ${response.body}');
  print('statusCode: ${response.statusCode}');
}
    if (response.statusCode == 200) {

        print('stnavPageatusCode: $navPage');
      }

      if (navPage == 'GPIN') {
        if(printStatementStatus){
          print("calling Gpin from notification service");}

        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            const GooglePinCodePage()));

      }
    }
  }

bool _isRequestingPermission = false;


Future<String?> fetchFcmTokenWithRetries({int maxRetries = 2}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      final token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        return token;
      }
    } catch (e) {
      debugPrint('FCM token attempt $attempt failed: $e');
    }

    if (attempt < maxRetries) {
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  return null;
}
// Future<String?> fetchFcmTokenWithRetries({int maxRetries = 1}) async {
//   for (int attempt = 1; attempt <= maxRetries; attempt++) {
//     try {
//       final token = await FirebaseMessaging.instance.getToken();
//       if (token != null) {
//         return token;
//       }
//     } catch (e) {
//       if(printStatementStatus){
//         print('Attempt $attempt: Error fetching FCM token: $e');
//         log('Attempt $attempt: Error fetching FCM token: $e');
//       }
//
//     }
//     await Future.delayed(
//         const Duration(seconds: 2)); // Small delay before retrying
//   }
//   return null; // Return null after exhausting retries
// }
Future<void> saveFcmToken(
    String entityID,
    BuildContext context,
    String navPage,
    String tok,
    String bToken,
    String mob,
    String mpin,
    ) async {
  if (_isRequestingPermission) {
    debugPrint("Permission request already in progress.");
    return;
  }

  _isRequestingPermission = true;

  try {
    await FirebaseMessaging.instance.requestPermission();

    final fcmToken = await fetchFcmTokenWithRetries();

    // Navigate immediately.
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavBar(),
      ),
          (route) => false,
    );

    // Save/register token in background.
    if (fcmToken != null) {
      SharedPref.shared.setFcmToken(fcmToken);

      try {
        await NotificationService().addFcmToken(
          fcmToken,
          bToken,
          entityID,
          context,
          navPage,
          mob,
        );

        debugPrint('FCM token saved successfully');
      } catch (e) {
        debugPrint('Failed to register FCM token: $e');
      }
    }
  } catch (e, stacktrace) {
    debugPrint('Error in saving FCM token: $e');
    debugPrint('$stacktrace');

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavBar(),
      ),
          (route) => false,
    );
  } finally {
    _isRequestingPermission = false;
  }
}
/*Future<void> saveFcmToken(
    String entityID, BuildContext context,
    String navPage, String tok,
    String mob, String mpin
    ) async
{
  if (_isRequestingPermission) {
    if(printStatementStatus){
      print("Permission request is already in progress.");
    }

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
            entityID, context, navPage,  mob),
        Future.delayed(const Duration(seconds: 5),
                () => throw TimeoutException("Server call timed out"))
      ]);
      if (_isRequestingPermission) {
        print('FCM token saved successfully');
        log('FCM token saved successfully');
      }

       SharedPref.shared.setFcmToken(fcmToken);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false,
      );
      if (_isRequestingPermission) {
        if(printStatementStatus){
          print('Failed to fetch FCM token after retries');
          log('Failed to fetch FCM token after retries');
        }

      }

    }
  } catch (e, stacktrace) {
    if (_isRequestingPermission) {
      if(printStatementStatus){
        print('Error in saving FCM token: $e');
        log('Error in saving FCM token: $e');
        log('Stacktrace: $stacktrace');
      }

    }

  } finally {
    _isRequestingPermission = false; // Reset the flag
  }
}*/

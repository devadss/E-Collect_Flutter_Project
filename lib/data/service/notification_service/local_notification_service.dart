import 'dart:developer';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
  const AndroidInitializationSettings('@mipmap/adsspay_logo_notification');

  void initInfo() async {
    DarwinInitializationSettings iosInitializationSetting =
    const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: _androidInitializationSettings, iOS: iosInitializationSetting);


    // await _flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.requestNotificationsPermission();

    // final val = await AndroidFlutterLocalNotificationsPlugin()
    //     .requestExactAlarmsPermission();
    // log('val: $val');
    // final List<PendingNotificationRequest> pendingNotificationRequests =
    //     await _flutterLocalNotificationsPlugin.pendingNotificationRequests();



    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
          try {
            if (payload.payload != null) {
            } else {}
          } catch (e) {}
          return;
        });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(".... .onMessage.... ");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        visibility: NotificationVisibility.public,
        'Offers',
        'Promotions',
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        color: const Color(0xffdcaa47),
        icon: '@mipmap/adsspay_logo_notification',
      );

      const iosNotificatonDetail = DarwinNotificationDetails();
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics, iOS: iosNotificatonDetail);
// sound: RowResourceAndroidNotificationSound("notification'),

      // NotificationDetails platformChannelSpecifics =
      //     NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
          payload: message.data['body']);
    });
  }



  Future<NotificationDetails> _notificationDetails({
    required String title,
    required String body,
  }) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      visibility: NotificationVisibility.public,
      'Offers',
      'Promotions',
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      color: const Color(0xffdcaa47),
      icon: '@mipmap/adsspay_logo_notification',
    );

    const iosNotificatonDetail = DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificatonDetail);
    return platformChannelSpecifics;
  }

  void requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }
}
import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// :small_blue_diamond: Global variable to hold pending notification when app not ready yet
RemoteMessage? pendingNotification;
// Handle notification tap in background or terminated state
Future<void> handleBackgroundMessage(RemoteMessage? message) async {
  if (message == null) return;
  print('Notification tapped (background/terminated): ${message.notification?.title}');
  handleMessage(message);
}

// Handle message tap logic
void handleMessage(RemoteMessage? message) async {
  if (message == null) return;
  var mapData = message.data;
  print('Notification tapped, mapData: $mapData');
  // :large_yellow_circle: If HomeController not ready yet, store for later
}

class PushNotificationFirebase {
  final firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // Start notification setup
  Future<void> showInit() async {
    await requestNotificationPermission();
  }

  // Request notification permission and init handlers
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      carPlay: true,
    );
    print('Notification permission status: ${settings.authorizationStatus}');
    await initPushNotifications();
    await initLocalNotification();
  }

  // Initialize local notifications and tap response
  Future<void> initLocalNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final fcmToken = await firebaseMessaging.getToken();
    pref.setString('fcmTkn', fcmToken.toString());
    print('FCM Token: $fcmToken');
    var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosSettings = const DarwinInitializationSettings(
      requestSoundPermission: true,
      defaultPresentSound: true,
    );
    var initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final tappedMsg = RemoteMessage.fromMap(jsonDecode(response.payload!));
          handleMessage(tappedMsg);
        }
      },
    );
  }

  // Initialize Firebase messaging with tap handlers
  Future<void> initPushNotifications() async {
    // Background/minimized tap handler
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);
    // Terminated state tap handler
    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('App launched from terminated by notification tap');
      handleMessage(initialMessage);
    }
    // Foreground message handler (no navigation)
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification == null) return;
      var mapData = message.data;
      print('Foreground message received, data: $mapData');
      if (mapData.containsKey('status_message')) {
        if (mapData['status_message'] == 'Force Out') {
          Get.dialog(
            AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "તમારું એકાઉન્ટ દૂર કરવામાં આવી રહ્યું છે",
                    style: TextStyle(
                      fontFamily: 'urbanist',
                      fontWeight: FontWeight.w500,
                      fontSize: Get.width / 24,
                      color: dark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            barrierDismissible: false,
          );
          Future.delayed(const Duration(seconds: 10), () {
            if (Get.isDialogOpen ?? false) Get.back();
            forceLogFromAdmin();
          });
        }
        if (mapData['status_message'] == 'Unapprove Account') {
          forceLogFromAdmin();
        }
      }
      showNotifications(message);
    });
  }

  // Display notification popup
  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'firebase_freshmart',
      Random.secure().nextInt(100000).toString(),
      description: 'Freshmart notification channel',
      importance: Importance.max,
    );
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: jsonEncode(message.toMap()),
    );
  }
}

// Forced logout function
forceLogFromAdmin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  prefs.remove('fcmTkn');
  prefs.remove('token');
  prefs.remove('UserData');
  Get.offAllNamed(AppRouter.login);
}

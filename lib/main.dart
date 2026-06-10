import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_point/app/push_notification/push_notification.dart';
import 'package:fresh_point/utility/init.dart';
import 'package:fresh_point/utility/language_list.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {}
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await MainBinding().dependencies();

  // Load saved language from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String langCode = prefs.getString('langCode') ?? 'gu';
  String countryCode = prefs.getString('countryCode') ?? 'IN';

  // Firebase initialization (platform-wise)
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyAdSZHeB3ApVxZB2dVj_tiASwgNR-r8uhY',
        appId: '1:841257963436:android:853be6a31624c0a83d7409',
        messagingSenderId: '841257963436',
        projectId: 'fresh-mart-909ee',
        storageBucket: 'fresh-mart-909ee.firebasestorage.app',
      ),
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyDCBl4DNr7oXORVG0NGIAUilinZXbDW8a0',
        appId: '1:841257963436:android:853be6a31624c0a83d7409',
        messagingSenderId: '841257963436',
        projectId: 'fresh-mart-909ee',
        storageBucket: 'fresh-mart-909ee.firebasestorage.app',
        iosBundleId: 'com.mz.freshmart',
      ),
    );
  }

  // Firebase Messaging background handler
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  PushNotificationFirebase().showInit();

  // Sentry init with app runner
  await SentryFlutter.init(
    (options) {
      options.dsn = ''; // Add your DSN here when ready
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      MyApp(
        locale: Locale(langCode, countryCode),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRouter.splash,
      getPages: AppRouter.routes,
    );
  }
}

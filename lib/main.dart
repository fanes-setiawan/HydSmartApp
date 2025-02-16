import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';
import 'package:hyd_smart_app/presentations/navbar.dart';
import 'package:hyd_smart_app/data/helper/db_helper.dart';
import 'package:hyd_smart_app/core/components/logging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hyd_smart_app/common/message/fcm_token.dart';
import 'package:hyd_smart_app/common/message/local_notifications.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  dlg("Received background message: ${message.notification?.title}");
  final db = DBHelper();
  await Firebase.initializeApp();

  await db.insertNotification(
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    timestamp: DateTime.now(),
  );
  LocalNotifications.showNotification(
    0,
    message.notification?.title ?? 'No Title',
    message.notification?.body ?? 'No Body',
    message.data.toString(),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await LocalNotifications.init();
  setupFirebaseMessaging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hyd Smart App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        dialogBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
        useMaterial3: true,
      ),
      home: const NavBar(),
    );
  }
}

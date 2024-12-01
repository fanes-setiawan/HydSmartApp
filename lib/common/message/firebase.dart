import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hyd_smart_app/data/helper/db_helper.dart';
import 'package:hyd_smart_app/core/components/logging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  static void initialize(BuildContext context) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Mendapatkan token FCM (gunakan jika Anda perlu mengirim notifikasi ke perangkat ini)
    messaging.getToken().then((token) {
      dlg("FCM Token: $token");
    });

    // Listener untuk notifikasi saat aplikasi di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dlg("Notifikasi diterima: ${message.notification?.title}");
      if (message.notification != null) {
        _saveNotificationToLocal(
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          timestamp: DateTime.now(),
        );
      }
    });

    // Listener untuk notifikasi yang di-klik
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      dlg("Notifikasi diklik: ${message.notification?.title}");
    });
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    dlg('---------------> Background Handler');
    final db = DBHelper();
    await Firebase.initializeApp();

    await db.insertNotification(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      timestamp: DateTime.now(),
    );
    dlg("Notifikasi background disimpan ke lokal");
  }

  static Future<void> _saveNotificationToLocal({
    required String title,
    required String body,
    required DateTime timestamp,
  }) async {
    await DBHelper().insertNotification(
      title: title,
      body: body,
      timestamp: timestamp,
    );
    dlg("Notifikasi disimpan ke lokal");
  }
}

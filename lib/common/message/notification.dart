import 'package:firebase_messaging/firebase_messaging.dart';

void setupFirebaseMessaging() {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Minta izin notifikasi
  messaging.requestPermission();

  // Cetak token FCM untuk testing
  messaging.getToken().then((token) {
    print("FCM Token: $token");
  });

  // Listener untuk menerima pesan saat aplikasi berjalan
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received: ${message.notification?.body}');
  });

  // Listener untuk pesan saat aplikasi di background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message clicked!');
  });
}

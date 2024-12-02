import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hyd_smart_app/core/components/logging.dart';

void setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  String? fcmToken = await messaging.getToken();
  if (fcmToken != null) {
    _sendTokenToFirestore(fcmToken);
  }
  messaging.onTokenRefresh.listen((newToken) {
    _sendTokenToFirestore(newToken);
  });

  // Listener untuk menerima pesan saat aplikasi berjalan
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    dlg('Pesan diterima: ${message.notification?.body}');
  });

  // Listener untuk pesan saat aplikasi di background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    dlg('Pesan diklik!');
  });
}
void _sendTokenToFirestore(String token) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    var userRef = firestore.collection('fcmTokens').doc("fcm-token");
    await userRef.set({
      'gcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    dlg("Token diperbarui atau disimpan ke Firestore.");
  } catch (e) {
    dlg("Gagal mengirim token ke Firestore: $e");
  }
}

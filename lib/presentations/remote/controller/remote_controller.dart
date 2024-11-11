import 'package:hyd_smart_app/data/models/settings.dart';
import 'package:hyd_smart_app/data/helper/db_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;

class RemoteController {
  final fire.FirebaseFirestore _firestore = fire.FirebaseFirestore.instance;
  final void Function(bool automatic, bool waterPump, bool mixer) onSettingsChanged;

  RemoteController({
    required this.onSettingsChanged,
  });

  bool automatic = false;
  bool waterPump = false;
  bool mixer = false;

  Future<void> loadSettings() async {
    // Load dari SQLite
    final settings = await DBHelper().getSettingsById(1);

    if (settings != null) {
      automatic = settings.automatic;
      waterPump = settings.waterPump;
      mixer = settings.mixer;
      onSettingsChanged(automatic, waterPump, mixer);
    } else {
      await DBHelper().insertSettings(Settings(
        id: 1,
        automatic: false,
        waterPump: false,
        mixer: false,
      ));
    }

    // Load dari Firestore
    final doc = await _firestore.collection('remote').doc('OrNOJUjtHdOhIgvnP2Yq').get();
    if (doc.exists) {
      final data = doc.data()!;
      automatic = data['auto'] ?? false;
      waterPump = data['waterPump'] ?? false;
      mixer = data['mixer'] ?? false;
      onSettingsChanged(automatic, waterPump, mixer);
    }
  }

  Future<void> updateSettings() async {
    final newSettings = Settings(
      id: 1,
      automatic: automatic,
      waterPump: waterPump,
      mixer: mixer,
    );

    await DBHelper().updateSettings(newSettings);
    print("Settings updated in SQLite");

    await _firestore.collection('remote').doc('OrNOJUjtHdOhIgvnP2Yq').update({
      'auto': automatic,
      'waterPump': waterPump,
      'mixer': mixer,
    });

    print("Settings updated in Firestore");
  }

  // Tambahkan metode untuk mengubah nilai
  void setAutomatic(bool value) {
    automatic = value;
    onSettingsChanged(automatic, waterPump, mixer);
  }

  void setWaterPump(bool value) {
    waterPump = value;
    onSettingsChanged(automatic, waterPump, mixer);
  }

  void setMixer(bool value) {
    mixer = value;
    onSettingsChanged(automatic, waterPump, mixer);
  }

  // Fungsi untuk memperbarui field di Firestore
  Future<void> updateFirestoreField(String field, dynamic value) async {
    await _firestore.collection('remote').doc('OrNOJUjtHdOhIgvnP2Yq').update({
      field: value,
    });
    print("$field updated to $value in Firestore");
  }
}

import 'package:flutter/material.dart';
import 'package:hyd_smart_app/data/models/settings.dart';
import 'package:hyd_smart_app/data/helper/db_helper.dart';
import 'package:hyd_smart_app/core/components/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:hyd_smart_app/common/message/showTopSnackBarWithActions.dart';
import 'package:hyd_smart_app/presentations/remote/view/calibration_view.dart';

class RemoteController {
  final fire.FirebaseFirestore _firestore = fire.FirebaseFirestore.instance;
  final void Function(
          bool automatic, bool waterPump, bool mixer, int auto_check)
      onSettingsChanged;

  RemoteController({
    required this.onSettingsChanged,
  });

  bool automatic = false;
  bool waterPump = false;
  bool mixer = false;
  int autoCheck = 1;

  Future<void> loadSettings() async {
    // Load dari SQLite
    final settings = await DBHelper().getSettingsById(1);

    if (settings != null) {
      automatic = settings.automatic;
      waterPump = settings.waterPump;
      mixer = settings.mixer;
      onSettingsChanged(automatic, waterPump, mixer, autoCheck);
    } else {
      await DBHelper().insertSettings(Settings(
          id: 1,
          automatic: false,
          waterPump: false,
          mixer: false,
          autoCheck: 1));
    }

    final doc =
        await _firestore.collection('remote').doc('OrNOJUjtHdOhIgvnP2Yq').get();
    if (doc.exists) {
      final data = doc.data()!;
      automatic = data['auto'] ?? false;
      waterPump = data['waterPump'] ?? false;
      mixer = data['mixer'] ?? false;
      autoCheck = data['autoCheck'] ?? 1;
      onSettingsChanged(automatic, waterPump, mixer, autoCheck);
    }
  }

  Future<void> updateSettings() async {
    final newSettings = Settings(
        id: 1,
        automatic: automatic,
        waterPump: waterPump,
        mixer: mixer,
        autoCheck: autoCheck);

    await DBHelper().updateSettings(newSettings);
    dlg("Settings updated in SQLite");

    await _firestore.collection('remote').doc('OrNOJUjtHdOhIgvnP2Yq').update({
      'auto': automatic,
      'waterPump': waterPump,
      'mixer': mixer,
      'autoCheck': autoCheck
    });

    dlg("Settings updated in Firestore");
  }

  void setAutomatic(bool value) {
    automatic = value;
    onSettingsChanged(automatic, waterPump, mixer, autoCheck);
  }

  void setWaterPump(bool value) {
    waterPump = value;
    onSettingsChanged(automatic, waterPump, mixer, autoCheck);
  }

  void setMixer(bool value) {
    mixer = value;
    onSettingsChanged(automatic, waterPump, mixer, autoCheck);
  }

  void setAutoCheck(int dataNumber) {
    autoCheck = dataNumber;
    onSettingsChanged(automatic, waterPump, mixer, autoCheck);
  }


  Future<void> updateFirestoreField(String field, dynamic value) async {
    await _firestore.collection('remote').doc('OrNOJUjtHdOhIgvnP2Yq').update({
      field: value,
    });
    dlg("$field updated to $value in Firestore");
  }

  void showConfirmDialog(BuildContext context, String sensorName, String type) {
    showTopSnackBarWithActions(
      context: context,
      title: 'Kalibrasi Sensor $sensorName',
      message: 'Apakah Anda Sudah Memasukan Probe Pada Larutan Standar?',
      textButton1: 'Cancel',
      textButton2: 'Continue',
      tapButton2: () {
        if (type == "tds") {
          showCalibrationDialog(context, "tds");
        } else if (type == "ph") {
          showCalibrationDialog(context, "ph");
        }
      },
    );
  }
}

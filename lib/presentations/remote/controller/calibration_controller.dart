import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;
// ignore_for_file: public_member_api_docs, sort_constructors_first

class CalibrationController extends ChangeNotifier {
  String? sensorName;
  int counter = 10;
  late Timer _timer;
  int step = 1;
  final fire.FirebaseFirestore _firestore = fire.FirebaseFirestore.instance;
  final TextEditingController controllerText = TextEditingController();
  bool isInputValid = false;
  CalibrationController({
    this.sensorName,
  });

  void startCountdown(VoidCallback onCountdownComplete ,double? liquidPH) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 0) {
        counter--;
        notifyListeners();

        if (counter == 5) {
          sensorName == 'tds'
              ? calibrationRequestTDS()
              : calibrationRequestPH(liquidPH!);
        }
      } else {
        _timer.cancel();
        onCountdownComplete();
      }
    });
  }

  Future<void> calibrationRequestTDS() async {
    try {
      await _firestore
          .collection('calibration')
          .doc('tds_sensor_admin')
          .update({
        'status': true,
        'fluid_ppm': int.parse(controllerText.text),
      });
    } catch (_) {
    }
  }

  Future<void> calibrationRequestPH(double liquidStandar) async {
    try {
      await _firestore.collection('calibration').doc('ph_sensor_admin').update({
        'status': true,
        'ph_value': liquidStandar,
      });
    } catch (_) {
    }
  }

  void nextStep() {
    step = 2;
    notifyListeners();
  }

  void disposeController() {
    _timer.cancel();
    controllerText.dispose();
  }
}

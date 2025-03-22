import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyd_smart_app/core/components/logging.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class HomeController {
  BuildContext context;
  void Function(void Function()) setState;
  HomeController({
    required this.context,
    required this.setState,
  });

  var lastPh = 0.0;
  var lastTds = 0.0;

  final StreamController<double> _lastPhController =
      StreamController<double>.broadcast();
  Stream<double> get lastPhStream => _lastPhController.stream;

  final StreamController<double> _lastTdsController =
      StreamController<double>.broadcast();
  Stream<double> get lastTdsStream => _lastTdsController.stream;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getSensorDataStream() {
    dlg('Getting sensor data stream...');
    return _firestore
        .collection('phData')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.docs
          .map((doc) {
            try {
              return {
                'createdAt': DateFormat('EEE HH:mm:ss').format(
                  (doc.data()['createdAt'] as Timestamp).toDate(),
                ),
                'phLevel': doc.data()['phLevel'] as num,
              };
            } catch (e) {
              dlg('Error mapping document: $e');
              return null;
            }
          })
          .where((element) => element != null)
          .cast<Map<String, dynamic>>()
          .toList();
      if (data.isNotEmpty) {
        lastPh = data.first['phLevel'].toDouble();
        _lastPhController.add(lastPh);
        dlg('Updated lastPh: $lastPh');
      }

      dlg('Mapped data pH ::: $data');
      return data.reversed.toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getNutrisiDataStream() {
    dlg('Getting nutrisi data stream...');
    return _firestore
        .collection('tdsData')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.docs
          .map((doc) {
            try {
              return {
                'createdAt': DateFormat('EEE HH:mm:ss').format(
                  (doc.data()['createdAt'] as Timestamp).toDate(),
                ),
                'tdsLevel': doc.data()['tdsLevel'] as num,
              };
            } catch (e) {
              dlg('Error mapping nutrisi document: $e');
              return null;
            }
          })
          .where((element) => element != null)
          .cast<Map<String, dynamic>>()
          .toList();
      if (data.isNotEmpty) {
        lastTds = data.first['tdsLevel'].toDouble();
        _lastTdsController.add(lastTds);
        dlg('Updated lastTds: $lastTds');
      }
      dlg('Mapped nutrisi data: $data');
      return data.reversed.toList(); // Data terbaru ada di bawah
    });
  }
}

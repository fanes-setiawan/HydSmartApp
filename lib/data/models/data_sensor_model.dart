import 'package:cloud_firestore/cloud_firestore.dart';
// lib/models/data_point.dart

class DataSensor {
  final double value;
  final DateTime createdAt;

  DataSensor({required this.value, required this.createdAt});

  factory DataSensor.fromFirestore(Map<String, dynamic> data) {
    return DataSensor(
      value: (data['value'] ?? 0).toDouble(),
      createdAt: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

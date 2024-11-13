class SensorModel {
  final int? id;
  final String createdAt;
  final double value;

  SensorModel({this.id, required this.createdAt, required this.value});

  // Konversi dari Map (SQLite) ke Model
  factory SensorModel.fromMap(Map<String, dynamic> map) {
    return SensorModel(
      id: map['id'],
      createdAt: map['createdAt'],
      value: map['value'],
    );
  }

  // Konversi dari Model ke Map (untuk SQLite)
  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'value': value,
    };
  }
}

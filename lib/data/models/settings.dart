// models/settings.dart

class Settings {
  int? id;
  bool automatic;
  bool waterPump;
  bool mixer;

  Settings({
    this.id,
    required this.automatic,
    required this.waterPump,
    required this.mixer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'automatic': automatic ? 1 : 0, // Menyimpan boolean sebagai 1 atau 0
      'water_pump': waterPump ? 1 : 0,
      'mixer': mixer ? 1 : 0,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      id: map['id'],
      automatic: map['automatic'] == 1,
      waterPump: map['water_pump'] == 1,
      mixer: map['mixer'] == 1,
    );
  }
}

// models/settings.dart

class Settings {
  int? id;
  bool automatic;
  bool waterPump;
  bool mixer;
  int autoCheck;

  Settings({
    this.id,
    required this.automatic,
    required this.waterPump,
    required this.mixer,
    required this.autoCheck,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'automatic': automatic ? 1 : 0, 
      'water_pump': waterPump ? 1 : 0,
      'mixer': mixer ? 1 : 0,
      'auto_check':autoCheck
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      id: map['id'],
      automatic: map['automatic'] == 1,
      waterPump: map['water_pump'] == 1,
      mixer: map['mixer'] == 1,
      autoCheck: map['auto_check']??1
    );
  }
}

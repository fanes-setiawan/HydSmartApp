import 'package:path/path.dart';
import '../models/settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hyd_smart_app/data/models/sensor_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabel settings
        await db.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            automatic INTEGER NOT NULL,
            water_pump INTEGER NOT NULL,
            mixer INTEGER NOT NULL
          )
        ''');

        // Tabel sensorDataPh
        await db.execute('''
          CREATE TABLE sensorDataPh(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            createdAt TEXT NOT NULL,
            value REAL NOT NULL
          )
        ''');
      },
    );
  }

  // Metode untuk tabel settings
  Future<int> updateSettings(Settings settings) async {
    final db = await database;
    return await db.update(
      'settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }

  Future<int> insertSettings(Settings settings) async {
    final db = await database;
    return await db.insert('settings', settings.toMap());
  }

  Future<Settings?> getSettingsById(int id) async {
    final db = await database;
    final maps = await db.query(
      'settings',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Settings.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Metode untuk tabel sensorDataPh
  Future<int> insertSensorData(SensorModel data) async {
    final db = await database;
    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM sensorDataPh')) ?? 0;

    // Jika sudah ada 5 data, hapus data paling lama
    if (count >= 5) {
      await deleteOldestSensorData();
    }
    return await db.insert('sensorDataPh', data.toMap());
  }

  Future<List<SensorModel>> fetchSensorData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sensorDataPh',
      orderBy: "id DESC",
      limit: 5,
    );

    // Konversi dari Map ke Model
    return List.generate(maps.length, (i) {
      return SensorModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteOldestSensorData() async {
    final db = await database;
    await db.delete('sensorDataPh', where: "id = (SELECT MIN(id) FROM sensorDataPh)");
  }
}

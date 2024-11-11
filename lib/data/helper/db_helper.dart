import 'package:path/path.dart';
import '../models/settings.dart';
import 'package:sqflite/sqflite.dart';
// helpers/db_helper.dart


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
    final path = join(dbPath, 'settings.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            automatic INTEGER NOT NULL,
            water_pump INTEGER NOT NULL,
            mixer INTEGER NOT NULL
          )
        ''');
      },
    );
  }

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
}

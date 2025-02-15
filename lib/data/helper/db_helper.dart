import 'package:path/path.dart';
import '../models/settings.dart';
import 'package:sqflite/sqflite.dart';
// ignore_for_file: depend_on_referenced_packages

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

    return await openDatabase(path, version: 3, onCreate: (db, version) async {
      // Tabel settings
      await db.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            automatic INTEGER NOT NULL,
            water_pump INTEGER NOT NULL,
            mixer INTEGER NOT NULL,
            auto_check INTEGER NOT NULL
          )
        ''');
      // Tabel notifications
      await db.execute('''
          CREATE TABLE notifications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            timestamp TEXT,
            isRead INTEGER DEFAULT 0
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
            'ALTER TABLE settings ADD COLUMN auto_check INTEGER DEFAULT 0');

        await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        isRead INTEGER DEFAULT 0
      )
    ''');
      }
      if (oldVersion < 3) {
        // Check if 'auto_check' column exists, if not, add it
        var columns = await db.rawQuery('PRAGMA table_info(settings)');
        bool autoCheckExists =
            columns.any((column) => column['name'] == 'auto_check');
        if (!autoCheckExists) {
          await db.execute(
              'ALTER TABLE settings ADD COLUMN auto_check INTEGER DEFAULT 0');
        }
      }
    });
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE settings ADD COLUMN auto_check INTEGER DEFAULT 0');
    }
  }

  // ---------------- SETTINGS METHODS ----------------

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
  // ---------------- NOTIFICATIONS METHODS ----------------

  Future<int> insertNotification({
    required String title,
    required String body,
    required DateTime timestamp,
  }) async {
    final db = await database;
    return await db.insert('notifications', {
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': 0,
    });
  }

  Stream<List<Map<String, dynamic>>> getAllNotifications() async* {
    final db = await database;

    yield* Stream.periodic(
      const Duration(seconds: 1),
      (_) async {
        return await db.query('notifications', orderBy: 'timestamp DESC');
      },
    ).asyncMap((event) => event);
  }

  //delete all
  Future<void> deleteAllNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }

  Stream<List<Map<String, dynamic>>> getUnreadNotifications() async* {
    final db = await database;

    // Query SQLite setiap kali ada perubahan
    yield* Stream.periodic(
      const Duration(seconds: 1),
      (_) async {
        final result = await db.query(
          'notifications',
          where: 'isRead = 0',
        );
        return result;
      },
    ).asyncMap((event) => event);
  }

  Future<void> markNotificationAsRead(int id) async {
    final db = await database;
    await db.update(
      'notifications',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markAllNotificationsAsRead() async {
    final db = await database;
    await db.update(
      'notifications',
      {'isRead': 1},
    );
  }

  Future<void> deleteNotification(int id) async {
    final db = await database;
    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getUnreadNotificationCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notifications WHERE isRead = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/models/data_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'data.db');
    return await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, subname TEXT, time TEXT,hour TEXT, location TEXT, color TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('DROP TABLE IF EXISTS data');
          await db.execute(
            'CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, subname TEXT, time TEXT,hour TEXT, location TEXT, color TEXT)',
          );
        }
      },
    );
  }

  Future<void> insertData(DataModel data) async {
    final db = await database;
    await db.insert(
      'data',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DataModel>> fetchData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('data');

    return List.generate(maps.length, (i) {
      return DataModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteData(int id) async {
    final db = await database;
    await db.delete(
      'data',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<DataModel?> getEventById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'data',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DataModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<DataModel>> getAllEvents() async {
     final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');

    return List.generate(maps.length, (i) {
      return DataModel.fromJson(maps[i]);
    });
  }
   Future<void> updateEvent(DataModel event) async {
    final db = await database;
    await db.update(
      'data',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }
}

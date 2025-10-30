import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('trackrun.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id $textType,
        username $textType,
        color $textType,
        createdAt $textType,
        PRIMARY KEY (id)
      )
    ''');

    // Trajectories table
    await db.execute('''
      CREATE TABLE trajectories (
        id $textType,
        userId $textType,
        name $textType,
        startTime $textType,
        endTime $textTypeNullable,
        isActive $intType,
        distance $textTypeNullable,
        PRIMARY KEY (id),
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Coordinates table
    await db.execute('''
      CREATE TABLE coordinates (
        id $idType,
        userId $textType,
        trajectoryId $textType,
        latitude $realType,
        longitude $realType,
        timestamp $textType,
        h3Index $textTypeNullable,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (trajectoryId) REFERENCES trajectories (id)
      )
    ''');

    // Territories table
    await db.execute('''
      CREATE TABLE territories (
        h3Index $textType,
        userId $textType,
        conqueredAt $textType,
        color $textType,
        PRIMARY KEY (h3Index),
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Create indices for better query performance
    await db.execute('''
      CREATE INDEX idx_coordinates_trajectory 
      ON coordinates(trajectoryId)
    ''');

    await db.execute('''
      CREATE INDEX idx_coordinates_user 
      ON coordinates(userId)
    ''');

    await db.execute('''
      CREATE INDEX idx_territories_user 
      ON territories(userId)
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/territory.dart';

class TerritoryService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Territory> createTerritory(Territory territory) async {
    final db = await _dbHelper.database;
    await db.insert(
      'territories',
      territory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return territory;
  }

  Future<Territory?> getTerritoryByH3Index(String h3Index) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'territories',
      where: 'h3Index = ?',
      whereArgs: [h3Index],
    );

    if (maps.isNotEmpty) {
      return Territory.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Territory>> getTerritoriesByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'territories',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => Territory.fromMap(map)).toList();
  }

  Future<List<Territory>> getAllTerritories() async {
    final db = await _dbHelper.database;
    final maps = await db.query('territories');
    return maps.map((map) => Territory.fromMap(map)).toList();
  }

  Future<int> updateTerritory(Territory territory) async {
    final db = await _dbHelper.database;
    return db.update(
      'territories',
      territory.toMap(),
      where: 'h3Index = ?',
      whereArgs: [territory.h3Index],
    );
  }

  Future<int> deleteTerritory(String h3Index) async {
    final db = await _dbHelper.database;
    return db.delete(
      'territories',
      where: 'h3Index = ?',
      whereArgs: [h3Index],
    );
  }
}

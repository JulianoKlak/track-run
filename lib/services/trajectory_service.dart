import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/trajectory.dart';

class TrajectoryService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Trajectory> createTrajectory(Trajectory trajectory) async {
    final db = await _dbHelper.database;
    await db.insert('trajectories', trajectory.toMap());
    return trajectory;
  }

  Future<Trajectory?> getTrajectoryById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'trajectories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Trajectory.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Trajectory>> getTrajectoryByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'trajectories',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'startTime DESC',
    );
    return maps.map((map) => Trajectory.fromMap(map)).toList();
  }

  Future<Trajectory?> getActiveTrajectory(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'trajectories',
      where: 'userId = ? AND isActive = 1',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return Trajectory.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTrajectory(Trajectory trajectory) async {
    final db = await _dbHelper.database;
    return db.update(
      'trajectories',
      trajectory.toMap(),
      where: 'id = ?',
      whereArgs: [trajectory.id],
    );
  }

  Future<int> deleteTrajectory(String id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'trajectories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

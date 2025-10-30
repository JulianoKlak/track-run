import '../database/database_helper.dart';
import '../models/coordinate.dart';

class CoordinateService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Coordinate> createCoordinate(Coordinate coordinate) async {
    final db = await _dbHelper.database;
    final id = await db.insert('coordinates', coordinate.toMap());
    return Coordinate(
      id: id,
      userId: coordinate.userId,
      trajectoryId: coordinate.trajectoryId,
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
      timestamp: coordinate.timestamp,
      h3Index: coordinate.h3Index,
    );
  }

  Future<List<Coordinate>> getCoordinatesByTrajectoryId(
      String trajectoryId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'coordinates',
      where: 'trajectoryId = ?',
      whereArgs: [trajectoryId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((map) => Coordinate.fromMap(map)).toList();
  }

  Future<List<Coordinate>> getCoordinatesByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'coordinates',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => Coordinate.fromMap(map)).toList();
  }

  Future<List<Coordinate>> getAllCoordinates() async {
    final db = await _dbHelper.database;
    final maps = await db.query('coordinates', orderBy: 'timestamp DESC');
    return maps.map((map) => Coordinate.fromMap(map)).toList();
  }

  Future<int> deleteCoordinate(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'coordinates',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCoordinatesByTrajectoryId(String trajectoryId) async {
    final db = await _dbHelper.database;
    return db.delete(
      'coordinates',
      where: 'trajectoryId = ?',
      whereArgs: [trajectoryId],
    );
  }
}

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class UserService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<User> createUser(User user) async {
    final db = await _dbHelper.database;
    await db.insert('users', user.toMap());
    return user;
  }

  Future<User?> getUserById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await _dbHelper.database;
    final maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(String id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

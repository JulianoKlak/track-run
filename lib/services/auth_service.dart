import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import '../models/user.dart';
import 'user_service.dart';

class AuthService {
  final UserService _userService = UserService();
  static const String _currentUserIdKey = 'current_user_id';

  // Generate a random color for the user
  String _generateRandomColor() {
    final random = Random();
    final colors = [
      '#FF0000', // Red
      '#00FF00', // Green
      '#0000FF', // Blue
      '#FFFF00', // Yellow
      '#FF00FF', // Magenta
      '#00FFFF', // Cyan
      '#FFA500', // Orange
      '#800080', // Purple
      '#FFC0CB', // Pink
      '#A52A2A', // Brown
    ];
    return colors[random.nextInt(colors.length)];
  }

  // Register a new user
  Future<User> register(String username) async {
    // Check if username already exists
    final existingUser = await _userService.getUserByUsername(username);
    if (existingUser != null) {
      throw Exception('Username already exists');
    }

    final user = User(
      id: const Uuid().v4(),
      username: username,
      color: _generateRandomColor(),
      createdAt: DateTime.now(),
    );

    await _userService.createUser(user);
    await _saveCurrentUserId(user.id);
    return user;
  }

  // Login with username
  Future<User> login(String username) async {
    final user = await _userService.getUserByUsername(username);
    if (user == null) {
      throw Exception('User not found');
    }

    await _saveCurrentUserId(user.id);
    return user;
  }

  // Get current logged-in user
  Future<User?> getCurrentUser() async {
    final userId = await _getCurrentUserId();
    if (userId == null) return null;

    return await _userService.getUserById(userId);
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserIdKey);
  }

  // Save current user ID to preferences
  Future<void> _saveCurrentUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, userId);
  }

  // Get current user ID from preferences
  Future<String?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserIdKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final userId = await _getCurrentUserId();
    return userId != null;
  }
}

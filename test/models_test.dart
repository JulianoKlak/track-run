import 'package:flutter_test/flutter_test.dart';
import 'package:track_run/models/user.dart';
import 'package:track_run/models/trajectory.dart';
import 'package:track_run/models/coordinate.dart';
import 'package:track_run/models/territory.dart';

void main() {
  group('User Model Tests', () {
    test('User toMap and fromMap should work correctly', () {
      final user = User(
        id: 'test-id',
        username: 'testuser',
        color: '#FF0000',
        createdAt: DateTime.parse('2024-01-01T12:00:00Z'),
      );

      final map = user.toMap();
      expect(map['id'], 'test-id');
      expect(map['username'], 'testuser');
      expect(map['color'], '#FF0000');

      final userFromMap = User.fromMap(map);
      expect(userFromMap.id, user.id);
      expect(userFromMap.username, user.username);
      expect(userFromMap.color, user.color);
    });
  });

  group('Trajectory Model Tests', () {
    test('Trajectory toMap and fromMap should work correctly', () {
      final trajectory = Trajectory(
        id: 'traj-id',
        userId: 'user-id',
        name: 'Test Run',
        startTime: DateTime.parse('2024-01-01T12:00:00Z'),
        isActive: true,
      );

      final map = trajectory.toMap();
      expect(map['id'], 'traj-id');
      expect(map['userId'], 'user-id');
      expect(map['name'], 'Test Run');
      expect(map['isActive'], 1);

      final trajectoryFromMap = Trajectory.fromMap(map);
      expect(trajectoryFromMap.id, trajectory.id);
      expect(trajectoryFromMap.userId, trajectory.userId);
      expect(trajectoryFromMap.name, trajectory.name);
      expect(trajectoryFromMap.isActive, trajectory.isActive);
    });

    test('Trajectory with endTime should work correctly', () {
      final trajectory = Trajectory(
        id: 'traj-id',
        userId: 'user-id',
        name: 'Test Run',
        startTime: DateTime.parse('2024-01-01T12:00:00Z'),
        endTime: DateTime.parse('2024-01-01T13:00:00Z'),
        isActive: false,
        distance: 5.5,
      );

      final map = trajectory.toMap();
      expect(map['endTime'], isNotNull);
      expect(map['distance'], 5.5);

      final trajectoryFromMap = Trajectory.fromMap(map);
      expect(trajectoryFromMap.endTime, isNotNull);
      expect(trajectoryFromMap.distance, 5.5);
    });
  });

  group('Coordinate Model Tests', () {
    test('Coordinate toMap and fromMap should work correctly', () {
      final coordinate = Coordinate(
        userId: 'user-id',
        trajectoryId: 'traj-id',
        latitude: -23.5505,
        longitude: -46.6333,
        timestamp: DateTime.parse('2024-01-01T12:00:00Z'),
        h3Index: 'test-h3-index',
      );

      final map = coordinate.toMap();
      expect(map['userId'], 'user-id');
      expect(map['trajectoryId'], 'traj-id');
      expect(map['latitude'], -23.5505);
      expect(map['longitude'], -46.6333);
      expect(map['h3Index'], 'test-h3-index');

      final coordinateFromMap = Coordinate.fromMap(map);
      expect(coordinateFromMap.userId, coordinate.userId);
      expect(coordinateFromMap.trajectoryId, coordinate.trajectoryId);
      expect(coordinateFromMap.latitude, coordinate.latitude);
      expect(coordinateFromMap.longitude, coordinate.longitude);
      expect(coordinateFromMap.h3Index, coordinate.h3Index);
    });
  });

  group('Territory Model Tests', () {
    test('Territory toMap and fromMap should work correctly', () {
      final territory = Territory(
        h3Index: 'test-h3-index',
        userId: 'user-id',
        conqueredAt: DateTime.parse('2024-01-01T12:00:00Z'),
        color: '#00FF00',
      );

      final map = territory.toMap();
      expect(map['h3Index'], 'test-h3-index');
      expect(map['userId'], 'user-id');
      expect(map['color'], '#00FF00');

      final territoryFromMap = Territory.fromMap(map);
      expect(territoryFromMap.h3Index, territory.h3Index);
      expect(territoryFromMap.userId, territory.userId);
      expect(territoryFromMap.color, territory.color);
    });
  });
}

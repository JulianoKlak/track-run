import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:h3_flutter/h3_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/coordinate.dart';
import '../models/trajectory.dart';
import '../models/territory.dart';
import '../models/user.dart';
import 'coordinate_service.dart';
import 'trajectory_service.dart';
import 'territory_service.dart';

class LocationTrackingService {
  final CoordinateService _coordinateService = CoordinateService();
  final TrajectoryService _trajectoryService = TrajectoryService();
  final TerritoryService _territoryService = TerritoryService();
  final h3 = H3();

  StreamSubscription<Position>? _positionSubscription;
  Trajectory? _currentTrajectory;
  User? _currentUser;
  final Set<String> _visitedH3Indices = {};

  // Start tracking location for a user
  Future<void> startTracking(User user) async {
    _currentUser = user;
    
    // Check if there's already an active trajectory
    final activeTrajectory = await _trajectoryService.getActiveTrajectory(user.id);
    
    if (activeTrajectory != null) {
      _currentTrajectory = activeTrajectory;
      // Load previously visited territories
      final coordinates = await _coordinateService.getCoordinatesByTrajectoryId(activeTrajectory.id);
      for (var coord in coordinates) {
        if (coord.h3Index != null) {
          _visitedH3Indices.add(coord.h3Index!);
        }
      }
    } else {
      // Create new trajectory
      _currentTrajectory = Trajectory(
        id: const Uuid().v4(),
        userId: user.id,
        name: 'Run ${DateTime.now().toString()}',
        startTime: DateTime.now(),
        isActive: true,
      );
      await _trajectoryService.createTrajectory(_currentTrajectory!);
    }

    // Request permission
    await _requestLocationPermission();

    // Start listening to position updates
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _handlePositionUpdate(position);
    });
  }

  // Stop tracking
  Future<void> stopTracking() async {
    if (_positionSubscription != null) {
      await _positionSubscription!.cancel();
      _positionSubscription = null;
    }

    if (_currentTrajectory != null) {
      // Update trajectory as inactive
      final updatedTrajectory = Trajectory(
        id: _currentTrajectory!.id,
        userId: _currentTrajectory!.userId,
        name: _currentTrajectory!.name,
        startTime: _currentTrajectory!.startTime,
        endTime: DateTime.now(),
        isActive: false,
        distance: _currentTrajectory!.distance,
      );
      await _trajectoryService.updateTrajectory(updatedTrajectory);
      _currentTrajectory = null;
    }

    _visitedH3Indices.clear();
    _currentUser = null;
  }

  // Handle position updates
  Future<void> _handlePositionUpdate(Position position) async {
    if (_currentUser == null || _currentTrajectory == null) return;

    // Calculate H3 index for this position
    final h3Index = h3.geoToH3(
      position.latitude,
      position.longitude,
      10, // Resolution 10 (hexagons ~15m across)
    );

    // Save coordinate
    final coordinate = Coordinate(
      userId: _currentUser!.id,
      trajectoryId: _currentTrajectory!.id,
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      h3Index: h3Index,
    );
    await _coordinateService.createCoordinate(coordinate);

    // Check if this is a new territory
    if (!_visitedH3Indices.contains(h3Index)) {
      _visitedH3Indices.add(h3Index);
      
      // Check if territory is already claimed
      final existingTerritory = await _territoryService.getTerritoryByH3Index(h3Index);
      
      if (existingTerritory == null) {
        // Claim new territory
        final territory = Territory(
          h3Index: h3Index,
          userId: _currentUser!.id,
          conqueredAt: DateTime.now(),
          color: _currentUser!.color,
        );
        await _territoryService.createTerritory(territory);
      }
    }
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
  }

  // Get current position
  Future<Position> getCurrentPosition() async {
    await _requestLocationPermission();
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Check if tracking is active
  bool isTracking() {
    return _positionSubscription != null && _currentTrajectory != null;
  }
}

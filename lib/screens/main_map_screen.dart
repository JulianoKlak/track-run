import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:h3_flutter/h3_flutter.dart';
import '../models/user.dart';
import '../models/territory.dart';
import '../models/coordinate.dart';
import '../services/auth_service.dart';
import '../services/location_tracking_service.dart';
import '../services/territory_service.dart';
import '../services/coordinate_service.dart';
import 'login_screen.dart';
import 'trajectory_history_screen.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  final AuthService _authService = AuthService();
  final LocationTrackingService _trackingService = LocationTrackingService();
  final TerritoryService _territoryService = TerritoryService();
  final CoordinateService _coordinateService = CoordinateService();
  final h3 = H3();

  User? _currentUser;
  bool _isTracking = false;
  LatLng? _currentPosition;
  List<Territory> _territories = [];
  List<Coordinate> _allCoordinates = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadUserAndData();
  }

  Future<void> _loadUserAndData() async {
    final user = await _authService.getCurrentUser();
    if (user == null) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
      return;
    }

    setState(() {
      _currentUser = user;
    });

    await _loadTerritories();
    await _loadCurrentPosition();
  }

  Future<void> _loadTerritories() async {
    final territories = await _territoryService.getAllTerritories();
    setState(() {
      _territories = territories;
    });
  }

  Future<void> _loadCurrentPosition() async {
    try {
      final position = await _trackingService.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentPosition!, 15.0);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter localização: $e')),
        );
      }
    }
  }

  Future<void> _toggleTracking() async {
    if (_currentUser == null) return;

    if (_isTracking) {
      await _trackingService.stopTracking();
      setState(() {
        _isTracking = false;
      });
      await _loadTerritories();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rastreamento parado')),
        );
      }
    } else {
      try {
        await _trackingService.startTracking(_currentUser!);
        setState(() {
          _isTracking = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rastreamento iniciado')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao iniciar rastreamento: $e')),
          );
        }
      }
    }
  }

  Future<void> _logout() async {
    if (_isTracking) {
      await _trackingService.stopTracking();
    }
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  List<Polygon> _buildTerritoryPolygons() {
    final polygons = <Polygon>[];

    for (var territory in _territories) {
      try {
        final boundary = h3.h3ToGeoBoundary(territory.h3Index);
        final points = boundary
            .map((coord) => LatLng(coord.lat, coord.lng))
            .toList();

        final color = _parseColor(territory.color);
        polygons.add(
          Polygon(
            points: points,
            color: color.withOpacity(0.4),
            borderColor: color,
            borderStrokeWidth: 2.0,
            isFilled: true,
          ),
        );
      } catch (e) {
        // Skip invalid territories
      }
    }

    return polygons;
  }

  Color _parseColor(String colorString) {
    try {
      return Color(
        int.parse(colorString.substring(1), radix: 16) + 0xFF000000,
      );
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  void dispose() {
    if (_isTracking) {
      _trackingService.stopTracking();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Run - ${_currentUser?.username ?? ""}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TrajectoryHistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentPosition,
                zoom: 15.0,
                maxZoom: 18.0,
                minZoom: 5.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.trackrun',
                ),
                PolygonLayer(
                  polygons: _buildTerritoryPolygons(),
                ),
                if (_currentPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPosition!,
                        width: 40,
                        height: 40,
                        builder: (ctx) => Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: _loadTerritories,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'location',
            onPressed: _loadCurrentPosition,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'tracking',
            onPressed: _toggleTracking,
            icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
            label: Text(_isTracking ? 'Parar' : 'Iniciar'),
            backgroundColor: _isTracking ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }
}

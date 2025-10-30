import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../models/trajectory.dart';
import '../models/coordinate.dart';
import '../services/trajectory_service.dart';
import '../services/coordinate_service.dart';

class TrajectoryDetailScreen extends StatefulWidget {
  final String trajectoryId;

  const TrajectoryDetailScreen({super.key, required this.trajectoryId});

  @override
  State<TrajectoryDetailScreen> createState() => _TrajectoryDetailScreenState();
}

class _TrajectoryDetailScreenState extends State<TrajectoryDetailScreen> {
  final TrajectoryService _trajectoryService = TrajectoryService();
  final CoordinateService _coordinateService = CoordinateService();
  final MapController _mapController = MapController();

  Trajectory? _trajectory;
  List<Coordinate> _coordinates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final trajectory = await _trajectoryService.getTrajectoryById(widget.trajectoryId);
    final coordinates = await _coordinateService.getCoordinatesByTrajectoryId(widget.trajectoryId);

    setState(() {
      _trajectory = trajectory;
      _coordinates = coordinates;
      _isLoading = false;
    });

    if (_coordinates.isNotEmpty && mounted) {
      final center = LatLng(
        _coordinates.first.latitude,
        _coordinates.first.longitude,
      );
      _mapController.move(center, 15.0);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  String _formatDuration() {
    if (_trajectory == null || _trajectory!.endTime == null) {
      return 'Em andamento';
    }
    final duration = _trajectory!.endTime!.difference(_trajectory!.startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_trajectory?.name ?? 'Detalhes do Trajeto'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trajectory == null
              ? const Center(child: Text('Trajeto não encontrado'))
              : Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: _coordinates.isNotEmpty
                              ? LatLng(
                                  _coordinates.first.latitude,
                                  _coordinates.first.longitude,
                                )
                              : LatLng(-23.5505, -46.6333),
                          zoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.trackrun',
                          ),
                          if (_coordinates.isNotEmpty)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: _coordinates
                                      .map((c) => LatLng(c.latitude, c.longitude))
                                      .toList(),
                                  color: Colors.blue,
                                  strokeWidth: 4.0,
                                ),
                              ],
                            ),
                          if (_coordinates.isNotEmpty)
                            MarkerLayer(
                              markers: [
                                // Start marker
                                Marker(
                                  point: LatLng(
                                    _coordinates.first.latitude,
                                    _coordinates.first.longitude,
                                  ),
                                  width: 40,
                                  height: 40,
                                  builder: (ctx) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                // End marker
                                if (!_trajectory!.isActive)
                                  Marker(
                                    point: LatLng(
                                      _coordinates.last.latitude,
                                      _coordinates.last.longitude,
                                    ),
                                    width: 40,
                                    height: 40,
                                    builder: (ctx) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.stop,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _trajectory!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              Icons.calendar_today,
                              'Início',
                              _formatDateTime(_trajectory!.startTime),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.timer,
                              'Duração',
                              _formatDuration(),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.location_on,
                              'Pontos',
                              '${_coordinates.length}',
                            ),
                            if (_trajectory!.distance != null) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.straighten,
                                'Distância',
                                '${_trajectory!.distance!.toStringAsFixed(2)} km',
                              ),
                            ],
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.flag,
                              'Status',
                              _trajectory!.isActive ? 'Ativo' : 'Concluído',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

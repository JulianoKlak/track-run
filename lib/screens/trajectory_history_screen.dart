import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trajectory.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/trajectory_service.dart';
import 'trajectory_detail_screen.dart';

class TrajectoryHistoryScreen extends StatefulWidget {
  const TrajectoryHistoryScreen({super.key});

  @override
  State<TrajectoryHistoryScreen> createState() =>
      _TrajectoryHistoryScreenState();
}

class _TrajectoryHistoryScreenState extends State<TrajectoryHistoryScreen> {
  final AuthService _authService = AuthService();
  final TrajectoryService _trajectoryService = TrajectoryService();

  User? _currentUser;
  List<Trajectory> _trajectories = [];
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

    final user = await _authService.getCurrentUser();
    if (user == null) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    final trajectories = await _trajectoryService.getTrajectoryByUserId(user.id);

    setState(() {
      _currentUser = user;
      _trajectories = trajectories;
      _isLoading = false;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  String _formatDuration(Trajectory trajectory) {
    if (trajectory.endTime == null) {
      return 'Em andamento';
    }
    final duration = trajectory.endTime!.difference(trajectory.startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Trajetos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trajectories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.route,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum trajeto registrado',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Inicie uma corrida para começar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _trajectories.length,
                    itemBuilder: (context, index) {
                      final trajectory = _trajectories[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: trajectory.isActive
                                ? Colors.green
                                : Colors.blue,
                            child: Icon(
                              trajectory.isActive
                                  ? Icons.play_arrow
                                  : Icons.check,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            trajectory.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Início: ${_formatDateTime(trajectory.startTime)}'),
                              Text('Duração: ${_formatDuration(trajectory)}'),
                              if (trajectory.distance != null)
                                Text(
                                  'Distância: ${trajectory.distance!.toStringAsFixed(2)} km',
                                ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TrajectoryDetailScreen(
                                  trajectoryId: trajectory.id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

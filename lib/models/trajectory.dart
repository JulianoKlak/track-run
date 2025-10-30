class Trajectory {
  final String id;
  final String userId;
  final String name;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isActive;
  final double? distance;

  Trajectory({
    required this.id,
    required this.userId,
    required this.name,
    required this.startTime,
    this.endTime,
    required this.isActive,
    this.distance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isActive': isActive ? 1 : 0,
      'distance': distance,
    };
  }

  factory Trajectory.fromMap(Map<String, dynamic> map) {
    return Trajectory(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: map['endTime'] != null 
          ? DateTime.parse(map['endTime'] as String) 
          : null,
      isActive: map['isActive'] == 1,
      distance: map['distance'] as double?,
    );
  }
}

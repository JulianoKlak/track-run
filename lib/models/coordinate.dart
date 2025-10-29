class Coordinate {
  final int? id;
  final String userId;
  final String trajectoryId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? h3Index;

  Coordinate({
    this.id,
    required this.userId,
    required this.trajectoryId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.h3Index,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'trajectoryId': trajectoryId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'h3Index': h3Index,
    };
  }

  factory Coordinate.fromMap(Map<String, dynamic> map) {
    return Coordinate(
      id: map['id'] as int?,
      userId: map['userId'] as String,
      trajectoryId: map['trajectoryId'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      timestamp: DateTime.parse(map['timestamp'] as String),
      h3Index: map['h3Index'] as String?,
    );
  }
}

class Territory {
  final String h3Index;
  final String userId;
  final DateTime conqueredAt;
  final String color;

  Territory({
    required this.h3Index,
    required this.userId,
    required this.conqueredAt,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'h3Index': h3Index,
      'userId': userId,
      'conqueredAt': conqueredAt.toIso8601String(),
      'color': color,
    };
  }

  factory Territory.fromMap(Map<String, dynamic> map) {
    return Territory(
      h3Index: map['h3Index'] as String,
      userId: map['userId'] as String,
      conqueredAt: DateTime.parse(map['conqueredAt'] as String),
      color: map['color'] as String,
    );
  }
}

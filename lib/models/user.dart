class User {
  final String id;
  final String username;
  final String color;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.color,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      color: map['color'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

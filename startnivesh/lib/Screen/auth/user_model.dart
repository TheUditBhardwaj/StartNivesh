class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'].toString(),
      email: map['email'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt,
    };
  }
}
class User {
  final String id;
  final String email;
  final String fullName;
  final String passwordHash;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.passwordHash,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullName': fullName,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      passwordHash: json['passwordHash'],
    );
  }
}
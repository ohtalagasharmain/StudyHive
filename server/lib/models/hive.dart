class Hive {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final List<String> members;

  Hive({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.members,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'creatorId': creatorId,
        'members': members,
      };

  factory Hive.fromJson(Map<String, dynamic> json) {
    return Hive(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      creatorId: json['creatorId'],
      members: List<String>.from(json['members']),
    );
  }
}

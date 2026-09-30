class Resource {
  final String id;
  final String title;
  final String type;
  final String date;
  final String path;
  final String userId;
  final String hiveId;
  final int quantity;
  final int quantityCap;
  final String rarity;
  final double multiplier;
  final double bonus;
  final String sourceOfAcquisition;
  final int lastUpdated;
  final int schemaVersion;

  Resource({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.path,
    required this.userId,
    required this.hiveId,
    this.quantity = 1,
    this.quantityCap = 100,
    this.rarity = 'common',
    this.multiplier = 1.0,
    this.bonus = 0.0,
    this.sourceOfAcquisition = 'general',
    int? lastUpdated,
    this.schemaVersion = 1,
  }) : lastUpdated = lastUpdated ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'date': date,
        'path': path,
        'userId': userId,
        'hiveId': hiveId,
        'quantity': quantity,
        'quantityCap': quantityCap,
        'rarity': rarity,
        'multiplier': multiplier,
        'bonus': bonus,
        'sourceOfAcquisition': sourceOfAcquisition,
        'lastUpdated': lastUpdated,
        'schemaVersion': schemaVersion,
      };

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? 'doc',
      date: json['date'] ?? '',
      path: json['path'] ?? '',
      userId: json['userId'] ?? '1',
      hiveId: json['hiveId'] ?? '',
      quantity: json['quantity'] as int? ?? 1,
      quantityCap: json['quantityCap'] as int? ?? 100,
      rarity: json['rarity'] as String? ?? 'common',
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
      bonus: (json['bonus'] as num?)?.toDouble() ?? 0.0,
      sourceOfAcquisition: json['sourceOfAcquisition'] as String? ?? 'general',
      lastUpdated: json['lastUpdated'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      schemaVersion: json['schemaVersion'] as int? ?? 1,
    );
  }
}
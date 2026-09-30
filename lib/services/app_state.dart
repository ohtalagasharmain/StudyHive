import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final String time;
  final bool isOutgoing;
  final String? fileName;
  final String? filePath;
  final bool isFile;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
    this.isOutgoing = false,
    this.fileName,
    this.filePath,
    this.isFile = false,
  });
}

enum StudyMaterialType { pdf, doc, ppt, image, link }

class StudyMaterial {
  final String id;
  final String title;
  final StudyMaterialType type;
  final String date;
  final String path;
  final Uint8List? bytes;
  final IconData icon;
  final Color color;
  final int quantity;
  final int quantityCap;
  final String rarity;
  final double multiplier;
  final double bonus;
  final String sourceOfAcquisition;
  final int lastUpdated;
  final int schemaVersion;

  StudyMaterial({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.path,
    this.bytes,
    required this.icon,
    required this.color,
    this.quantity = 1,
    this.quantityCap = 100,
    this.rarity = 'common',
    this.multiplier = 1.0,
    this.bonus = 0.0,
    this.sourceOfAcquisition = 'general',
    int? lastUpdated,
    this.schemaVersion = 1,
  }) : lastUpdated = lastUpdated ?? DateTime.now().millisecondsSinceEpoch;

  StudyMaterial copyWith({
    String? id,
    String? title,
    StudyMaterialType? type,
    String? date,
    String? path,
    Uint8List? bytes,
    IconData? icon,
    Color? color,
    int? quantity,
    int? quantityCap,
    String? rarity,
    double? multiplier,
    double? bonus,
    String? sourceOfAcquisition,
    int? lastUpdated,
    int? schemaVersion,
  }) {
    final effectiveCap = quantityCap ?? this.quantityCap;
    return StudyMaterial(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      path: path ?? this.path,
      bytes: bytes ?? this.bytes,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      quantity: (quantity ?? this.quantity).clamp(0, effectiveCap),
      quantityCap: effectiveCap,
      rarity: rarity ?? this.rarity,
      multiplier: multiplier ?? this.multiplier,
      bonus: bonus ?? this.bonus,
      sourceOfAcquisition: sourceOfAcquisition ?? this.sourceOfAcquisition,
      lastUpdated: lastUpdated ?? DateTime.now().millisecondsSinceEpoch,
      schemaVersion: schemaVersion ?? this.schemaVersion,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.name,
        'date': date,
        'path': path,
        'quantity': quantity,
        'quantityCap': quantityCap,
        'rarity': rarity,
        'multiplier': multiplier,
        'bonus': bonus,
        'sourceOfAcquisition': sourceOfAcquisition,
        'lastUpdated': lastUpdated,
        'schemaVersion': schemaVersion,
      };

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    int version = json['schemaVersion'] as int? ?? 0;
    if (version < 1) {
      json = _migrateSchemaToV1(json);
    }

    final typeName = json['type'] as String? ?? 'doc';
    final type = _parseMaterialType(typeName);

    return StudyMaterial(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'Untitled Material',
      type: type,
      date: json['date'] ?? 'Recently',
      path: json['path'] ?? '',
      icon: _getIconForType(type),
      color: _getColorForType(type),
      quantity: json['quantity'] as int? ?? 1,
      quantityCap: json['quantityCap'] as int? ?? 100,
      rarity: json['rarity'] as String? ?? 'common',
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
      bonus: (json['bonus'] as num?)?.toDouble() ?? 0.0,
      sourceOfAcquisition: json['sourceOfAcquisition'] as String? ?? 'general',
      lastUpdated: json['lastUpdated'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      schemaVersion: 1,
    );
  }

  static Map<String, dynamic> _migrateSchemaToV1(Map<String, dynamic> oldJson) {
    final Map<String, dynamic> migrated = Map<String, dynamic>.from(oldJson);
    migrated['quantity'] = oldJson['quantity'] ?? 1;
    migrated['quantityCap'] = oldJson['quantityCap'] ?? 100;
    migrated['rarity'] = oldJson['rarity'] ?? 'common';
    migrated['multiplier'] = oldJson['multiplier'] ?? 1.0;
    migrated['bonus'] = oldJson['bonus'] ?? 0.0;
    migrated['sourceOfAcquisition'] = oldJson['sourceOfAcquisition'] ?? 'legacy_import';
    migrated['lastUpdated'] = oldJson['lastUpdated'] ?? DateTime.now().millisecondsSinceEpoch;
    migrated['schemaVersion'] = 1;
    return migrated;
  }

  static StudyMaterialType _parseMaterialType(String name) {
    switch (name.toLowerCase()) {
      case 'pdf': return StudyMaterialType.pdf;
      case 'doc':
      case 'docx': return StudyMaterialType.doc;
      case 'ppt':
      case 'pptx': return StudyMaterialType.ppt;
      case 'image': return StudyMaterialType.image;
      case 'link': return StudyMaterialType.link;
      default: return StudyMaterialType.doc;
    }
  }

  static IconData _getIconForType(StudyMaterialType type) {
    switch (type) {
      case StudyMaterialType.pdf: return Icons.picture_as_pdf;
      case StudyMaterialType.doc: return Icons.description;
      case StudyMaterialType.ppt: return Icons.slideshow;
      case StudyMaterialType.image: return Icons.image;
      case StudyMaterialType.link: return Icons.link;
    }
  }

  static Color _getColorForType(StudyMaterialType type) {
    switch (type) {
      case StudyMaterialType.pdf: return const Color(0xFFEF5350);
      case StudyMaterialType.doc: return const Color(0xFF42A5F5);
      case StudyMaterialType.ppt: return const Color(0xFFFF9800);
      case StudyMaterialType.image: return const Color(0xFF66BB6A);
      case StudyMaterialType.link: return const Color(0xFFD97706);
    }
  }
}

class UserSession {
  final DateTime startTime;
  final DateTime endTime;
  final String topic;

  UserSession({required this.startTime, required this.endTime, required this.topic});

  int get durationInMinutes => endTime.difference(startTime).inMinutes;
}

class QuizResult {
  final String id;
  final String topic;
  final int score;
  final int total;
  final DateTime date;

  QuizResult({
    required this.id,
    required this.topic,
    required this.score,
    required this.total,
    required this.date,
  });
}

class HiveData {
  String id;
  String name;
  String subject;
  int members;
  String icon;
  Color color;
  bool owned;
  bool joined;
  bool favorite;
  List<String> membersList;
  String latestMessage;
  String latestMessageTime;
  int unreadMessages;
  int mastery;
  List<ChatMessage> messages;
  List<StudyMaterial> materials;

  HiveData({
    required this.id,
    required this.name,
    required this.subject,
    this.members = 1,
    this.icon = '🐝',
    this.color = const Color(0xFFD97706),
    this.owned = true,
    this.joined = true,
    this.favorite = false,
    this.membersList = const ['You'],
    this.latestMessage = 'Hive created!',
    this.latestMessageTime = 'Now',
    this.unreadMessages = 0,
    this.mastery = 0,
    List<ChatMessage>? messages,
    List<StudyMaterial>? materials,
  }) : messages = messages ?? [],
       materials = materials ?? [];
}

class UserData {
  String name;
  String username;
  String bio;
  String grade;
  String subjects;
  String school;
  String? profilePicturePath;

  UserData({
    required this.name,
    required this.username,
    this.bio = 'Focused on learning, one session at a time.',
    this.grade = 'Grade 11',
    this.subjects = 'Physics, Mathematics',
    this.school = '',
    this.profilePicturePath,
  });
}

class AppState extends ChangeNotifier with WidgetsBindingObserver {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  static const int currentSchemaVersion = 1;
  static const String backendUrl = 'http://localhost:8080';

  UserData _user = UserData(name: 'Study Hive', username: 'studyhive');
  final List<HiveData> _hives = [];
  final List<UserSession> _sessions = [];
  final List<StudyMaterial> _savedResources = [];
  final List<QuizResult> _quizHistory = [];

  bool _isDarkMode = false;
  String _languageCode = 'en';

  Timer? _saveDebounceTimer;
  Timer? _periodicSaveTimer;
  bool _isSaving = false;

  UserData get user => _user;
  List<HiveData> get hives => _hives;
  List<UserSession> get sessions => _sessions;
  List<StudyMaterial> get savedResources => List.unmodifiable(_savedResources);
  List<QuizResult> get quizHistory => _quizHistory;
  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;

  int get studyStreak {
    if (_sessions.isEmpty) return 0;
    return 5;
  }

  double get dailyProgress {
    if (_sessions.isEmpty) return 0.0;
    int totalToday = _sessions.fold(0, (sum, s) => sum + s.durationInMinutes);
    return (totalToday / 60).clamp(0.0, 1.0);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      saveResourcesToStorageAndServer();
    }
  }

  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _languageCode = prefs.getString('languageCode') ?? 'en';

    String? userJson = prefs.getString('user_data');
    if (userJson != null) {
      Map<String, dynamic> map = jsonDecode(userJson);
      _user = UserData(
        name: map['name'],
        username: map['username'],
        bio: map['bio'],
        grade: map['grade'],
        subjects: map['subjects'],
        school: map['school'],
        profilePicturePath: map['profilePicturePath'],
      );
    }

    initMockData();
    await restoreUserResources(_user.username);
    _startPeriodicAutoSave();
    notifyListeners();
  }

  void _startPeriodicAutoSave() {
    _periodicSaveTimer?.cancel();
    _periodicSaveTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      saveResourcesToStorageAndServer();
    });
  }

  void _triggerDebouncedAutoSave() {
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(const Duration(milliseconds: 1500), () {
      saveResourcesToStorageAndServer();
    });
  }

  Future<void> restoreUserResources(String userId) async {
    _savedResources.clear();
    final prefs = await SharedPreferences.getInstance();
    final localKey = 'user_resources_$userId';
    final localJson = prefs.getString(localKey);

    List<StudyMaterial> restoredList = [];

    // 1. Retrieve from local storage
    if (localJson != null && localJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(localJson);
        if (decoded is Map<String, dynamic> && decoded['resources'] != null) {
          final rawResources = decoded['resources'] as List;
          restoredList = rawResources
              .map((item) => StudyMaterial.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
      } catch (e) {
        debugPrint('Error decoding local resources: $e');
      }
    }

    // 2. Retrieve from remote server for consistency
    try {
      final response = await http.get(
        Uri.parse('$backendUrl/resources?userId=$userId'),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final List remoteData = jsonDecode(response.body);
        final remoteList = remoteData
            .map((item) => StudyMaterial.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        if (remoteList.isNotEmpty) {
          for (final remoteItem in remoteList) {
            final idx = restoredList.indexWhere((r) => r.id == remoteItem.id);
            if (idx == -1) {
              restoredList.add(remoteItem);
            } else if (remoteItem.lastUpdated >= restoredList[idx].lastUpdated) {
              restoredList[idx] = remoteItem;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Offline mode or server query failed: $e');
    }

    // 3. First-time login: initialize default resources
    if (restoredList.isEmpty) {
      restoredList = _getInitialDefaultResources();
    }

    _savedResources.addAll(restoredList);
    await saveResourcesToStorageAndServer();
    notifyListeners();
  }

  List<StudyMaterial> _getInitialDefaultResources() {
    return [];
  }

  Future<void> saveResourcesToStorageAndServer() async {
    if (_isSaving) return;
    _isSaving = true;

    final userId = _user.username;
    final localKey = 'user_resources_$userId';

    try {
      final payloadMap = {
        'userId': userId,
        'schemaVersion': currentSchemaVersion,
        'savedAt': DateTime.now().millisecondsSinceEpoch,
        'resources': _savedResources.map((r) => r.toJson()).toList(),
      };

      // Atomic write buffer to local storage
      final jsonString = jsonEncode(payloadMap);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(localKey, jsonString);

      // Backend sync write
      await http.post(
        Uri.parse('$backendUrl/resources/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'schemaVersion': currentSchemaVersion,
          'resources': _savedResources.map((r) => r.toJson()).toList(),
        }),
      ).timeout(const Duration(seconds: 4));
    } catch (e) {
      debugPrint('Save operation cached locally (server sync notice: $e)');
    } finally {
      _isSaving = false;
    }
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void setLanguage(String langCode) async {
    _languageCode = langCode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', _languageCode);
    notifyListeners();
  }

  void updateUser(UserData newUser) async {
    if (_user.username != newUser.username) {
      await saveResourcesToStorageAndServer();
    }
    _user = newUser;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', jsonEncode({
      'name': _user.name,
      'username': _user.username,
      'bio': _user.bio,
      'grade': _user.grade,
      'subjects': _user.subjects,
      'school': _user.school,
      'profilePicturePath': _user.profilePicturePath,
    }));

    await restoreUserResources(_user.username);
    notifyListeners();
  }

  void signOut() async {
    await saveResourcesToStorageAndServer();
    _saveDebounceTimer?.cancel();
    _periodicSaveTimer?.cancel();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    _user = UserData(name: 'Study Hive', username: 'studyhive');
    _sessions.clear();
    _savedResources.clear();
    notifyListeners();
  }

  void addHive(HiveData hive) {
    _hives.add(hive);
    notifyListeners();
  }

  void updateHive(String id, String newName, String newSubject, String newDesc) {
    final index = _hives.indexWhere((h) => h.id == id);
    if (index != -1) {
      _hives[index].name = newName;
      _hives[index].subject = newSubject;
      notifyListeners();
    }
  }

  void addMember(String hiveId, String memberName) {
    final hive = _hives.firstWhere((h) => h.id == hiveId);
    if (!hive.membersList.contains(memberName)) {
      hive.membersList.add(memberName);
      hive.members = hive.membersList.length;
      notifyListeners();
    }
  }

  void removeMember(String hiveId, String memberName) {
    final hive = _hives.firstWhere((h) => h.id == hiveId);
    hive.membersList.remove(memberName);
    hive.members = hive.membersList.length;
    notifyListeners();
  }

  void sendMessage(String hiveId, ChatMessage message) {
    final hive = _hives.firstWhere((h) => h.id == hiveId);
    hive.messages.add(message);
    hive.latestMessage = message.isFile ? 'Shared a file: ${message.fileName}' : message.text;
    hive.latestMessageTime = message.time;
    notifyListeners();
  }

  void addMaterial(String hiveId, StudyMaterial material) {
    final hive = _hives.firstWhere((h) => h.id == hiveId);
    hive.materials.add(material);
    notifyListeners();
  }

  Future<void> deleteMaterial(String hiveId, String materialId) async {
    final hive = _hives.firstWhere((h) => h.id == hiveId);

    // Remove it locally first so the UI updates immediately.
    hive.materials.removeWhere((m) => m.id == materialId);
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse(
          'http://localhost:8080/resources/$materialId',
        ),
      );

      if (response.statusCode != 200) {
        debugPrint(
          'Failed to delete resource: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error deleting resource: $e');
    }
  }

  Future<void> saveResource(StudyMaterial material) async {
    final existingIndex = _savedResources.indexWhere((m) => m.id == material.id);
    if (existingIndex != -1) {
      final existing = _savedResources[existingIndex];
      _savedResources[existingIndex] = existing.copyWith(
        quantity: existing.quantity + 1,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      _savedResources.add(material.copyWith(
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
      ));
    }
    notifyListeners();
    _triggerDebouncedAutoSave();
  }

  void updateResourceQuantity(String id, int newQuantity) {
    final idx = _savedResources.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _savedResources[idx] = _savedResources[idx].copyWith(
        quantity: newQuantity,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
      );
      notifyListeners();
      _triggerDebouncedAutoSave();
    }
  }

  void removeSavedResource(String id) {
    _savedResources.removeWhere((m) => m.id == id);
    notifyListeners();
    _triggerDebouncedAutoSave();
  }

  void addSession(UserSession session) {
    _sessions.add(session);
    notifyListeners();
  }

  void addQuizResult(QuizResult result) {
    _quizHistory.add(result);
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveDebounceTimer?.cancel();
    _periodicSaveTimer?.cancel();
    super.dispose();
  }

  void initMockData() {
    if (_hives.isNotEmpty) return;
    _hives.addAll([
      HiveData(
        id: 'physics-hive',
        name: 'Physics Hive',
        subject: 'Physics',
        members: 7,
        mastery: 78,
        icon: '🧪',
        color: const Color(0xFF42A5F5),
        membersList: ['Jai', 'Kirs', 'Derick', 'Kester', 'Clarine', 'Audrey', 'Matthew'],
        messages: [
          ChatMessage(id: '1', sender: 'Jai', text: 'Hello, everyone!.', time: '9:05 AM'),
          ChatMessage(id: '2', sender: 'You', text: 'hello, Jai! I will upload the PPT later.', time: '9:08 AM', isOutgoing: true),
        ],
        materials: [

        ],
        latestMessage: 'Jai: Just finished reviewing the formula sheet.',
        latestMessageTime: '9:11 AM',
        unreadMessages: 2,
      ),
      HiveData(
        id: 'math-scholars',
        name: 'Math Scholars',
        subject: 'Mathematics',
        members: 7,
        mastery: 65,
        icon: '📐',
        color: const Color(0xFF7E57C2),
        owned: false,
        membersList: ['Jai', 'Kirs', 'Derick', 'Kester', 'Clarine', 'Audrey', 'Matthew'],
        latestMessage: 'Matthew: The practice set is ready.',
        latestMessageTime: 'Yesterday',
      ),
    ]);
  }
}

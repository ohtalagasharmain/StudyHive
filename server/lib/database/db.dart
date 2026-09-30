import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_admin_sdk/firebase_admin_sdk.dart';
import 'package:google_cloud_firestore/google_cloud_firestore.dart'
    hide Credential;

import '../models/user.dart';
import '../models/hive.dart';
import '../models/resource.dart';

class Database {
  late final FirebaseApp firebaseApp;
  late final Firestore firestore;

  Database._internal() {
    firebaseApp = FirebaseApp.initializeApp(
      options: AppOptions(
        credential: Credential.fromServiceAccount(
          File('serviceAccountKey.json'),
        ),
      ),
    );

    firestore = firebaseApp.firestore();
  }

  static final Database _instance = Database._internal();

  factory Database() => _instance;

  final List<User> users = [
    User(
      id: '1',
      email: 'studyhive@gmail.com',
      fullName: 'Study Hive User',
      passwordHash: BCrypt.hashpw(
        'studyhive',
        BCrypt.gensalt(),
      ),
    ),
  ];

  final List<Hive> hives = [
    Hive(
      id: '101',
      name: 'Physics Hive',
      description: 'Quantum mechanics study group',
      creatorId: '1',
      members: ['1'],
    ),
  ];

  final List<Resource> resources = [];

  User? findUserByEmail(String email) {
    try {
      return users.firstWhere(
            (u) => u.email == email,
      );
    } catch (_) {
      return null;
    }
  }

  void addUser(User user) {
    users.add(user);
  }

  void addHive(Hive hive) {
    hives.add(hive);
  }

  Future<void> addResource(Resource resource) async {
    final index = resources.indexWhere(
          (r) => r.id == resource.id && r.userId == resource.userId,
    );

    if (index != -1) {
      resources[index] = resource;
    } else {
      resources.add(resource);
    }

    await firestore
        .collection('resources')
        .doc(resource.id)
        .set(resource.toJson());
  }

  Future<List<Resource>> getResources() async {
    final snapshot = await firestore
        .collection('resources')
        .get();

    final firestoreResources = snapshot.docs
        .map(
          (doc) => Resource.fromJson(doc.data()),
    )
        .toList();

    resources
      ..clear()
      ..addAll(firestoreResources);

    return resources;
  }

  List<Resource> getResourcesForUser(String userId) {
    return resources
        .where(
          (resource) => resource.userId == userId,
    )
        .toList();
  }

  void syncUserResources(
      String userId,
      List<Resource> newResources,
      ) {
    resources.removeWhere(
          (resource) => resource.userId == userId,
    );

    resources.addAll(newResources);
  }

  Future<void> deleteResource(
      String id, {
        String? userId,
      }) async {
    resources.removeWhere(
          (resource) =>
      resource.id == id &&
          (userId == null || resource.userId == userId),
    );

    await firestore
        .collection('resources')
        .doc(id)
        .delete();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final _db = FirebaseFirestore.instance;

  /// Adds a course to Firestore only if it doesn't already exist
  static Future<String> addCourse({
    required String name,
    required String instructor,
    required String overview,
    required bool isTheory,
  }) async {
    final existing = await _db
        .collection('courses')
        .where('name', isEqualTo: name)
        .get();

    if (existing.docs.isNotEmpty) {
      return existing.docs.first.id; // Return existing ID
    }

    final docRef = await _db.collection('courses').add({
      'name': name,
      'instructor': instructor,
      'overview': overview,
      'isTheory': isTheory,
      'createdAt': Timestamp.now(),
    });

    return docRef.id; // Return new document ID
  }}
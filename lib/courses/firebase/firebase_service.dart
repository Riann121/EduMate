import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final _db = FirebaseFirestore.instance;

  /// Adds a course to Firestore only if it doesn't already exist
  static Future<void> addCourse({
    required String name,
    required String instructor,
    required String overview,
    required bool isTheory,
  }) async {
    // Check if a course with the same name already exists
    final existing = await _db
        .collection('courses')
        .where('name', isEqualTo: name)
        .get();

    if (existing.docs.isNotEmpty) {
      return;      // Course already exists, do not add
    }

    // Add the course since it doesn't exist
    await _db.collection('courses').add({
      'name': name,
      'instructor': instructor,
      'overview': overview,
      'isTheory': isTheory,
      'createdAt': Timestamp.now(),
    });
    // print('Course "$name" added to Firebase successfully.');
  }
}
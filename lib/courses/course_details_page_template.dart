import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/lecture_item.dart';
import 'package:edumate/courses/utility/lecture_tile.dart';
import 'package:edumate/courses/utility/assignment_item.dart';
import 'package:edumate/courses/utility/assignment_tile.dart';
import 'package:edumate/courses/utility/add_item_dialog.dart';
import 'package:edumate/theme/app_colors.dart';

class CourseTemplatePage extends StatelessWidget {
  final String courseId;
  final String courseName;
  final String instructorName;
  final String overview;

  const CourseTemplatePage({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.instructorName,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    final courseRef = FirebaseFirestore.instance.collection('courses').doc(courseId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: Text(
          courseName,
          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ================= Overview =================
              _titleText("Overview"),
              Card(
                color: AppColors.surface,
                elevation: 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    overview,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ================= Assignments =================
              _titleText("Upcoming Assignments"),
              StreamBuilder<QuerySnapshot>(
                stream: courseRef.collection('assignments').orderBy('date').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final assignments = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return AssignmentItem(
                      title: data['title'],
                      dueDate: (data['date'] as Timestamp).toDate(),
                      details: data['details'] ?? '',
                    );
                  }).toList();

                  if (assignments.isEmpty) {
                    return const Text("No upcoming assignments.");
                  }

                  return Column(
                    children: assignments.map((a) {
                      return AssignmentCard(
                        assignment: a,
                        onTap: () {
                          // Optional: show details or allow deletion
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),

              // ================= Lectures =================
              _titleText("Upcoming Lectures"),
              StreamBuilder<QuerySnapshot>(
                stream: courseRef.collection('lectures').orderBy('date').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final lectures = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return LectureItem(
                      title: data['title'],
                      date: (data['date'] as Timestamp).toDate(),
                    );
                  }).toList();

                  if (lectures.isEmpty) {
                    return const Text("No upcoming lectures.");
                  }

                  return Column(
                    children: lectures.map((l) {
                      return LectureCard(
                        lecture: l,
                        onTap: () {
                          // Optional: show details or allow deletion
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddItemDialog(context: context, courseId: courseId);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _titleText(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
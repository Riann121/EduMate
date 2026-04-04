import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/firebase/firebase_service.dart';
// course structure
import 'package:edumate/courses/utility/course_item.dart';
import 'package:edumate/courses/utility/course_tile.dart';
import 'package:edumate/courses/utility/add_course_dialog.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});
  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to listen to real-time changes in Firestore
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Courses',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('courses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No courses found.'));
            }

            // Separate theory and lab courses
            final theoryCourses = <CourseItem>[];
            final labCourses = <CourseItem>[];

            for (var doc in snapshot.data!.docs) {
              final data = doc.data()! as Map<String, dynamic>;
              final course = CourseItem(
                data['name'],
                data['instructor'],
                CourseDetailPage(
                  courseId: doc.id,
                  courseName: data['name'],
                  instructorName: data['instructor'],
                  overview: data['overview'],
                  courseCode: '',
                ),
              );

              if (data['isTheory'] == true) {
                theoryCourses.add(course);
              } else {
                labCourses.add(course);
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Courses',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const SectionTitle('Theory'),
                  ...theoryCourses.map(
                        (c) => CourseTile(course: c, onTap: () => _openCourse(c)),
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 0.5, height: 24),
                  const SectionTitle('Lab'),
                  ...labCourses.map(
                        (c) => CourseTile(course: c, onTap: () => _openCourse(c)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddCustomCourseDialog(
            context: context,
            onAdd: (newCourse, isTheory) async {
              // Save the course to Firebase
              await FirebaseService.addCourse(
                name: newCourse.courseName,
                instructor: newCourse.teacherName,
                overview: (newCourse.page as CourseDetailPage).overview,
                isTheory: isTheory,
              );
            },
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _openCourse(CourseItem course) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => course.page));
  }
}

//-----------------------------------------------------

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}
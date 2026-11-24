import 'package:flutter/material.dart';
import 'package:edumate/services/local_storage_service.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/course_item.dart';
import 'package:edumate/courses/utility/course_tile.dart';
import 'package:edumate/courses/utility/add_course_dialog.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final LocalStorageService _storage = LocalStorageService();

  @override
  Widget build(BuildContext context) {
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
        child: ValueListenableBuilder(
          valueListenable: _storage.coursesListenable,
          builder: (context, box, child) {
            final courses = _storage.getAllCourses();

            if (courses.isEmpty) {
              return const Center(child: Text('No courses found. Tap + to add one.'));
            }

            final theoryCourses = <CourseItem>[];
            final labCourses = <CourseItem>[];

            for (var data in courses) {
              final course = CourseItem(
                data['name'] ?? '',
                data['instructor'] ?? '',
                CourseDetailPage(
                  courseId: data['id'] ?? '',
                  courseName: data['name'] ?? '',
                  instructorName: data['instructor'] ?? '',
                  overview: data['overview'] ?? '',
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
                  if (theoryCourses.isNotEmpty) ...[
                    const SectionTitle('Theory Courses'),
                    ...theoryCourses.map(
                      (c) => CourseTile(course: c, onTap: () => _openCourse(c)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (labCourses.isNotEmpty) ...[
                    if (theoryCourses.isNotEmpty)
                      const SizedBox(height: 12),
                    const SectionTitle('Lab Courses'),
                    ...labCourses.map(
                      (c) => CourseTile(course: c, onTap: () => _openCourse(c)),
                    ),
                  ],
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
              // Course is added via LocalStorageService inside dialog
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

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
}
import 'package:flutter/material.dart';
//course structure
import 'package:edumate/courses/utility/course_item.dart';
import 'package:edumate/courses/utility/course_tile.dart';
import 'package:edumate/courses/utility/add_course_dialog.dart';
//theory course pages
import 'theory/electronics.dart';
import 'theory/mathematics.dart';
import 'theory/ethics.dart';
import 'theory/data_structures.dart';
import 'theory/dld.dart';
//lab course pages
import 'lab/dld_lab.dart';
import 'lab/electronics_lab.dart';
import 'lab/sd_lab.dart';
import 'lab/data_structures_lab.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});
  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final List<CourseItem> _theoryCourses = [
    CourseItem('Data Structures', 'Siam Ansary', const DataStructures()),
    CourseItem('Electronics', 'SJ Hamim', const Electronics()),
    CourseItem('Ethics', 'Shamima Nasrin', const Ethics()),
    CourseItem('Mathematics', 'Ifte Khyrul Amin', const Mathematics()),
    CourseItem('Digital Logic Design', 'Shabnam Hasan', const DLD()),
  ];
  final List<CourseItem> _labCourses = [
    CourseItem(
      'Software Development Lab',
      'Fahim Ahmed',
      const SoftwareDevelopmentLab(),
    ),
    CourseItem('Data Structures Lab', 'Siam Ansary', const DataStructuresLab()),
    CourseItem('Electronics Lab', 'SJ Hamim', const ElectronicsLab()),
    CourseItem('Digital Logic Design Lab', 'Shabnam Hasan', const DLDLab()),
  ];

  void _openCourse(CourseItem course) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => course.page));
  }

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
        child: SingleChildScrollView(
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
              ..._theoryCourses.map(
                (c) => CourseTile(course: c, onTap: () => _openCourse(c)),
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 0.5, height: 24),
              const SectionTitle('Lab'),
              ..._labCourses.map(
                (c) => CourseTile(course: c, onTap: () => _openCourse(c)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddCustomCourseDialog(
            context: context,
            onAdd: (newCourse, isTheory) {
              setState(() {
                if (isTheory) {
                  _theoryCourses.add(newCourse);
                } else {
                  _labCourses.add(newCourse);
                }
              });
            },
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
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

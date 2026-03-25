import 'package:edumate/theme/app_colors.dart';
import 'package:flutter/material.dart';
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

/*

class _CoursesPageState extends State<CoursesPage> {
  final List<CourseItem> _theoryCourses = [
    CourseItem('Electronics', 'SJ Hamim', const Electronics()),
    CourseItem('Mathematics', 'Ifte Khyrul Amin', const Mathematics()),
    CourseItem('Ethics', 'Shamima Nasrin', const Ethics()),
    CourseItem('Data Structures', 'Siam Ansary', const DataStructures()),
    CourseItem('Digital Logic Design', 'Shabnam Hasan', const DLD()),
  ];
  final List<CourseItem> _labCourses = [
    CourseItem('Digital Logic Design Lab', 'Anika Binte Aftab', const DLDLab()),
    CourseItem('Electronics Lab', 'SJ Hamim', const ElectronicsLab()),
    CourseItem('Software Development Lab', 'Fahim Ahmed', const SoftwareDevelopmentLab(),),
    CourseItem('Data Structures Lab', 'Siam Ansary', const DataStructuresLab()),
  ];

  void _openCourse(CourseItem course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => course.page, // Open course page
      ),
    );
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

              // thin divider line before Lab section to separate
              const Divider(thickness: 0.5, height: 24),

              const SectionTitle('Lab'),
              ..._labCourses.map(
                (c) => CourseTile(course: c, onTap: () => _openCourse(c)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//---------------------------------
class CourseItem {
  final String courseName;
  final String teacherName;
  final Widget page;

  const CourseItem(this.courseName, this.teacherName, this.page);
}

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

/// clickable course tile.
class CourseTile extends StatelessWidget {
  final CourseItem course;
  final VoidCallback onTap;

  const CourseTile({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      child: Card(
        color: Color(0xFFF4F7FF),
        elevation: 1.5,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, //centered icon
            children: [
              //texts on left side
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.teacherName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '(IDK how many) assignments',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // RIGHT SIDE ICON
              const Icon(
                Icons.menu_book_outlined,
                size: 22,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
*/
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
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Courses',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),


          ],
      )),
      ),
    );
  }
}

//-----------------------------------------------------
class CourseItem {
  final String courseName;
  final String teacherName;
  final Widget page;

  const CourseItem(this.courseName, this.teacherName, this.page);
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
      ))
    );
}

class CourseTile extends StatelessWidget {
  final CourseItem course;
  final VoidCallback onTap;

  const CourseTile({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) =>
      InkWell(

        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          child: Card(
            color: Color(0xFFF4F7FF),
            elevation: 1.5,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    course.courseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                      fontSize: 14,
                    ),
                  ), const SizedBox(height: 4),
                  Text(course.teacherName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('No. of assignments',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}


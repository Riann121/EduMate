import 'package:flutter/material.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class ElectronicsLab extends StatelessWidget {
  const ElectronicsLab({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Electronics Lab',
      instructorName: 'SJ Hamim',
      overview: 'This is the beginning of Electronics Lab course...',

      assignments: [
        AssignmentItem(
          title: 'BJT Transistors',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
      ],

      lectures: const [],
    );
  }
}

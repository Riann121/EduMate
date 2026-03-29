import 'package:flutter/material.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class Electronics extends StatelessWidget {
  const Electronics({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Electronics',
      instructorName: 'SJ Hamim',
      overview:
          'This course introduces semiconductor devices, diodes, transistors, and circuit analysis.',

      assignments: [
        AssignmentItem(
          title: 'Diode Circuit Analysis',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
        AssignmentItem(
          title: 'Transistor Biasing',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
      ],

      lectures: const [
        LectureItem(title: 'Introduction to Electronics', date: '22/2/2026'),
        LectureItem(title: 'PN Junction Diode', date: '22/2/2026'),
        LectureItem(title: 'Transistors', date: '5/2/2026'),
      ],
    );
  }
}

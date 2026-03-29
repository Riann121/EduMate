import 'package:flutter/material.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class SoftwareDevelopmentLab extends StatelessWidget {
  const SoftwareDevelopmentLab({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Software Development Lab',
      instructorName: 'Fahim Ahmed',
      overview: 'This is the beginning of SD Lab course...',

      assignments: [
        AssignmentItem(
          title: 'UI Submission',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
      ],

      lectures: const [
        LectureItem(title: 'LAB Material 2', date: '22/2/2026'),
        LectureItem(title: 'LAB Material 1', date: '22/2/2026'),
      ],
    );
  }
}

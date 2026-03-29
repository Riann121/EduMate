import 'package:edumate/courses/utility/lecture_item.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class DLDLab extends StatelessWidget {
  const DLDLab({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Digital Logic Design Lab',
      instructorName: 'Anika Binte Aftab',
      overview: 'This is the beginning of DLD Lab course...',

      assignments: [
        AssignmentItem(
          title: 'Design BCD adder',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
      ],

      lectures: [
        LectureItem(
            title: 'LAB Material 1',
            date: DateTime(2026, 2, 20)
        )
      ],
    );
  }
}

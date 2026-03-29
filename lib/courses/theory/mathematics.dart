import 'package:edumate/courses/utility/lecture_item.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class Mathematics extends StatelessWidget {
  const Mathematics({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Mathematics',
      instructorName: 'Ifte Khyrul Amin',
      overview: 'This is the beginning of Mathematics course...',

      assignments: [
        AssignmentItem(
          title: 'Laplace transform',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
      ],

      lectures: [
        LectureItem(
          title: 'Inverse Laplace transform',
          date: DateTime(2026, 2, 20),
        ),
        LectureItem(
          title: 'Partial differential equations',
          date: DateTime(2026, 2, 20),
        ),
      ],
    );
  }
}

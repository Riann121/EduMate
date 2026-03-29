import 'package:flutter/material.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class Ethics extends StatelessWidget {
  const Ethics({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Ethics',
      instructorName: 'Shamima Nasrin',
      overview: 'This is the beginning of Ethics course...',

      assignments: [
        AssignmentItem(
          title: 'Ethics for engineers',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
      ],

      lectures: const [LectureItem(title: 'Ethics', date: '22/2/2026')],
    );
  }
}

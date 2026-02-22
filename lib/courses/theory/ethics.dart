import 'package:flutter/material.dart';
import 'package:edumate/courses//course_details_page_template.dart';

class Ethics extends StatelessWidget {
  const Ethics({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Ethics',
      instructorName: 'Shamima Nasrin',
      overview:
      'This is the beginning of Ethics course...',

      assignments: const [
        AssignmentItem(
          title: 'Ethics for engineers',
          dueDate: '22/2/2026',
          status: 'pending',
        ),
      ],

      lectures: const [
        LectureItem(
          title: 'Ethics',
          date: '22/2/2026',
        ),
      ],
    );
  }
}
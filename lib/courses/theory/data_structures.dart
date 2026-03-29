import 'package:edumate/courses/utility/lecture_item.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class DataStructures extends StatelessWidget {
  const DataStructures({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Data Structures',
      instructorName: 'Siam Ansary',
      overview: 'This is the beginning of DS course...',

      assignments: [
        AssignmentItem(
          title: 'Stack',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
      ],

      lectures: [
        LectureItem(
            title: 'Tree',
            date: DateTime(2026, 2, 20)
        ),
        LectureItem(
            title: 'Graph',
            date: DateTime(2026, 3, 31)
        ),
      ],
    );
  }
}

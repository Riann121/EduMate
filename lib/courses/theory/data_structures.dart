import 'package:flutter/material.dart';
import 'package:edumate/courses//course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class DataStructures extends StatelessWidget {
  const DataStructures({super.key});


  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Data Structures',
      instructorName: 'Siam Ansary',
      overview:
      'This is the beginning of DS course...',

      assignments: const [
        AssignmentItem(
          title: 'Stack',
          dueDate: '22/2/2026',
          details: '###',
        ),
      ],

      lectures: const [
        LectureItem(
          title: 'Tree',
          date: '22/2/2026',
        ),
        LectureItem(
          title: 'Graph',
          date: '22/2/2026',
        ),
      ],
    );
  }
}
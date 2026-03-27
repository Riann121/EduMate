import 'package:flutter/material.dart';
import 'package:edumate/courses//course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class DLDLab extends StatelessWidget {
  const DLDLab({super.key});


  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Digital Logic Design Lab',
      instructorName: 'Anika Binte Aftab',
      overview:
      'This is the beginning of DLD Lab course...',

      assignments: const [
        AssignmentItem(
          title: 'Design BCD adder',
          dueDate: '22/2/2026',
          details: '###',
        ),
      ],

      lectures: const [
      ],
    );
  }
}
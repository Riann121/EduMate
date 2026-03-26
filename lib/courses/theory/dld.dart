import 'package:flutter/material.dart';
import 'package:edumate/courses//course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class DLD extends StatelessWidget {
  const DLD({super.key});


  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Digital Logic Design',
      instructorName: 'Shabnam Hasan',
      overview:
      'This is the beginning of DLD course...',

      assignments: const [
        AssignmentItem(
          title: 'Multiplexers',
          dueDate: '22/2/2026',
          status: 'pending',
        ),
      ],

      lectures: const [
        LectureItem(
          title: 'Multiplexers',
          date: '22/2/2026',
        ),
        LectureItem(
          title: 'Combinational Circuits',
          date: '22/2/2026',
        ),
      ],
    );
  }
}
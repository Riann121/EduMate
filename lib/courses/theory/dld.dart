import 'package:flutter/material.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class DLD extends StatelessWidget {
  const DLD({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Digital Logic Design',
      instructorName: 'Shabnam Hasan',
      overview: 'This is the beginning of DLD course...',

      assignments: [
        AssignmentItem(
          title: 'Multiplexers',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
      ],

      lectures: [
        LectureItem(
            title: 'Multiplexers',
            date: DateTime(2026, 2, 20)
        ),
        LectureItem(
          title: 'Combinational Circuits',
          date: DateTime(2026, 3, 31),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:edumate/courses/course_details_page_template.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class DataStructuresLab extends StatelessWidget {
  const DataStructuresLab({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Data Structures Lab',
      instructorName: 'Siam Ansary',
      overview: 'This is the beginning of DS Lab course...',

      assignments: [
        AssignmentItem(
          title: 'Doubly linked list',
          dueDate: DateTime(2026, 3, 30),
          details: '###',
        ),
      ],

      lectures: [
        LectureItem(title: 'Singly Linked List', date: DateTime(2026, 2, 20)),
        LectureItem(title: 'Doubly Linked List', date: DateTime(2026, 3, 31)),
      ],
    );
  }
}

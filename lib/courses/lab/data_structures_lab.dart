import 'package:flutter/material.dart';
import 'package:edumate/courses//course_details_page_template.dart';

class DataStructuresLab extends StatelessWidget {
  const DataStructuresLab({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseTemplatePage(
      courseName: 'Data Structures Lab',
      instructorName: 'Siam Ansary',
      overview:
      'This is the beginning of DS Lab course...',

      assignments: const [
        AssignmentItem(
          title: 'Doubly linked list',
          dueDate: '22/2/2026',
          status: 'pending',
        ),
      ],

      lectures: const [
        LectureItem(
          title: 'Singly Linked List',
          date: '22/2/2026',
        ),
        LectureItem(
          title: 'Doubly Linked List',
          date: '22/2/2026',
        ),
      ],
    );
  }
}
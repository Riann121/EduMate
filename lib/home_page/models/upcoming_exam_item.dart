import 'package:flutter/material.dart';

class UpcomingExamItem {
  final String examTitle;
  final String courseName;
  final String syllabus;
  final DateTime examDate;

  const UpcomingExamItem({
    required this.examTitle,
    required this.courseName,
    required this.syllabus,
    required this.examDate,
  });

  UpcomingExamItem copyWith({
    String? examTitle,
    String? courseName,
    String? syllabus,
  }) {
    return UpcomingExamItem(
      examTitle: examTitle ?? this.examTitle,
      courseName: courseName ?? this.courseName,
      syllabus: syllabus ?? this.syllabus,
      examDate: examDate,
    );
  }
}

List<UpcomingExamItem> buildDummyUpcomingExamItems() {
  final today = DateUtils.dateOnly(DateTime.now());
  final weekEnd = today.add(const Duration(days: 6));

  final items = [
    UpcomingExamItem(
      examTitle: 'Quiz',
      courseName: 'Advanced Mathematics',
      syllabus: 'Limits, continuity, and differentiability',
      examDate: today.add(const Duration(days: 1)),
    ),
    UpcomingExamItem(
      examTitle: 'Mid Term',
      courseName: 'Computer Science',
      syllabus: 'Data structures, recursion, and algorithm analysis',
      examDate: today.add(const Duration(days: 3)),
    ),
    UpcomingExamItem(
      examTitle: 'Viva',
      courseName: 'Physics',
      syllabus: 'Work, energy, momentum, and collisions',
      examDate: today.add(const Duration(days: 4)),
    ),
  ];

  return items
      .where(
        (item) =>
            !item.examDate.isBefore(today) && !item.examDate.isAfter(weekEnd),
      )
      .toList();
}

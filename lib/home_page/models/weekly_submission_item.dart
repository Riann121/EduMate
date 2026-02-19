import 'package:flutter/material.dart';

class WeeklySubmissionItem {
  final String title;
  final String courseName;
  final String type;
  final DateTime dueDate;
  final bool isDone;

  const WeeklySubmissionItem({
    required this.title,
    required this.courseName,
    required this.type,
    required this.dueDate,
    this.isDone = false,
  });

  WeeklySubmissionItem copyWith({bool? isDone}) {
    return WeeklySubmissionItem(
      title: title,
      courseName: courseName,
      type: type,
      dueDate: dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}

List<WeeklySubmissionItem> buildDummyWeeklySubmissionItems() {
  final today = DateUtils.dateOnly(DateTime.now());
  final weekEnd = today.add(const Duration(days: 6));

  final items = [
    WeeklySubmissionItem(
      title: 'Midterm Review Worksheet',
      courseName: 'Advanced Mathematics',
      type: 'Assignment',
      dueDate: today,
    ),
    WeeklySubmissionItem(
      title: 'Lab Report: Momentum',
      courseName: 'Physics',
      type: 'Lab Report',
      dueDate: today.add(const Duration(days: 1)),
    ),
    WeeklySubmissionItem(
      title: 'Data Structures Project',
      courseName: 'Computer Science',
      type: 'Assignment',
      dueDate: today.add(const Duration(days: 2)),
    ),
    WeeklySubmissionItem(
      title: 'WWI Research Paper',
      courseName: 'World History',
      type: 'Assignment',
      dueDate: today.add(const Duration(days: 4)),
    ),
  ];

  return items
      .where(
        (item) =>
            !item.dueDate.isBefore(today) && !item.dueDate.isAfter(weekEnd),
      )
      .toList();
}

import 'package:edumate/courses/utility/assignment_item.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/lecture_item.dart';

class LectureCard extends StatelessWidget {
  final LectureItem lecture;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const LectureCard({
    super.key,
    required this.lecture,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEFEFEF),
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.library_books_outlined, color: Colors.black),
        title: Text(
          lecture.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Date: ${formatDate(lecture.date)}"),
        trailing: const Text('Upcoming', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
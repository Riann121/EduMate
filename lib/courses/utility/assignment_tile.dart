import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentItem assignment;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AssignmentCard({
    super.key,
    required this.assignment,
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
        leading: const Icon(Icons.assignment, color: Colors.black),
        title: Text(
          assignment.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Due: ${formatDate(assignment.dueDate)}"),
        trailing: const Text('Pending', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
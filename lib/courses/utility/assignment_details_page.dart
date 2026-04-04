import 'package:flutter/material.dart';
import 'assignment_item.dart';

void showAssignmentDetails({
  required BuildContext context,
  required AssignmentItem assignment,
  required VoidCallback onUpdate,
  required VoidCallback onDelete,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Text("Deadline: ${formatDate(assignment.dueDate)}"),
            const SizedBox(height: 10),
            const Text(
              "Details:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(assignment.details),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // DUE BUTTON
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Due"),
                ),

                // COMPLETE BUTTON
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Complete"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
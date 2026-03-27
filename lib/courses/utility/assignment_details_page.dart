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
      return StatefulBuilder(
        builder: (context, setModalState) {
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

                Text("Deadline: ${assignment.dueDate}"),
                const SizedBox(height: 10),
                Text("Details:"),
                const SizedBox(height: 10),
                Text(assignment.details),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // DOING BUTTON
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Doing",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    // FINISHED BUTTON
                    ElevatedButton(
                      onPressed: () {
                        onDelete(); // remove from list
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text("Finished"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

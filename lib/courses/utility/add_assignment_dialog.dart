import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

Future<void> showAddAssignmentDialog({
  required BuildContext context,
  required Function(AssignmentItem) onAdd,
}) async {
  final titleController = TextEditingController();
  final dueDateController = TextEditingController();
  final detailsController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add Assignment"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Assignment Title",
                  hintText: "Enter assignment title here...",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dueDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Due Date",
                  hintText: "Select due date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    dueDateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(
                  labelText: "Details",
                  hintText: "Enter assignment details here...",
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty ||
                  dueDateController.text.isEmpty) {
                return;
              }

              final newAssignment = AssignmentItem(
                title: titleController.text,
                dueDate: dueDateController.text,
                details: detailsController.text,
              );

              onAdd(newAssignment);
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}

import 'package:edumate/courses/utility/lecture_item.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/assignment_item.dart';

Future<void> showAddItemDialog({
  required BuildContext context,
  required Function(AssignmentItem) onAddAssignment,
  required Function(LectureItem) onAddLecture,
}) async {
  await showDialog(
    context: context,
    builder: (context) => _AddItemDialog(
      onAddAssignment: onAddAssignment,
      onAddLecture: onAddLecture,
    ),
  );
}

class _AddItemDialog extends StatefulWidget {
  final Function(AssignmentItem) onAddAssignment;
  final Function(LectureItem) onAddLecture;

  const _AddItemDialog({
    required this.onAddAssignment,
    required this.onAddLecture,
  });

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  late final TextEditingController titleController;
  late final TextEditingController dueDateController;
  late final TextEditingController detailsController;

  bool isAssignment = true;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    dueDateController = TextEditingController();
    detailsController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    dueDateController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  void _clearFields() {
    titleController.clear();
    dueDateController.clear();
    detailsController.clear();
    selectedDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Item"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Title
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: isAssignment ? "Assignment Title" : "Lecture Title",
              ),
            ),

            const SizedBox(height: 12),

            //Date
            TextField(
              controller: dueDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: isAssignment ? "Due Date" : "Lecture Date",
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  selectedDate = pickedDate;
                  dueDateController.text = formatDate(pickedDate);
                }
              },
            ),

            const SizedBox(height: 12),

            //Details(Assignments only)
            if (isAssignment)
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: "Details"),
                maxLines: null,
              ),

            if (isAssignment) const SizedBox(height: 12),

            //Type Selection
            RadioGroup<bool>(
              groupValue: isAssignment,
              onChanged: (value) {
                setState(() {
                  isAssignment = value!;
                  _clearFields();
                });
              },
              child: Row(
                children: const [
                  Text("Type: "),
                  SizedBox(width: 10),
                  Radio<bool>(value: true),
                  Text("Assignment"),
                  Radio<bool>(value: false),
                  Text("Lecture"),
                ],
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(onPressed: _handleAdd, child: const Text("Add")),
      ],
    );
  }

  void _handleAdd() {
    if (titleController.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    if (isAssignment) {
      final newAssignment = AssignmentItem(
        title: titleController.text,
        dueDate: selectedDate!,
        details: detailsController.text,
      );
      widget.onAddAssignment(newAssignment);
    } else {
      final newLecture = LectureItem(
        title: titleController.text,
        date: selectedDate!,
      );
      widget.onAddLecture(newLecture);
    }

    Navigator.pop(context);
  }
}

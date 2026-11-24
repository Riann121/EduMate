import 'package:flutter/material.dart';
import 'package:edumate/services/local_storage_service.dart';

Future<void> showAddItemDialog({
  required BuildContext context,
  required String courseId,
}) async {
  await showDialog(
    context: context,
    builder: (context) => _AddItemDialog(courseId: courseId),
  );
}

class _AddItemDialog extends StatefulWidget {
  final String courseId;

  const _AddItemDialog({required this.courseId});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  bool isAssignment = true;
  DateTime? selectedDate;

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  void _clearFields() {
    titleController.clear();
    dateController.clear();
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
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  labelText: isAssignment ? "Assignment Title" : "Lecture Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime(2035),
                );
                if (pickedDate != null && mounted) {
                  setState(() {
                    selectedDate = pickedDate;
                    dateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            if (isAssignment)
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: "Details"),
                maxLines: null,
              ),
            if (isAssignment) const SizedBox(height: 12),
            Row(
              children: [
                const Text("Type: "),
                const SizedBox(width: 10),
                Radio<bool>(
                  value: true,
                  groupValue: isAssignment,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        isAssignment = val;
                        _clearFields();
                      });
                    }
                  },
                ),
                const Text("Assignment"),
                Radio<bool>(
                  value: false,
                  groupValue: isAssignment,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        isAssignment = val;
                        _clearFields();
                      });
                    }
                  },
                ),
                const Text("Lecture"),
              ],
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

  Future<void> _handleAdd() async {
    if (titleController.text.trim().isEmpty || selectedDate == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    try {
      final storage = LocalStorageService();
      if (isAssignment) {
        await storage.addAssignment(
          courseId: widget.courseId,
          title: titleController.text.trim(),
          date: selectedDate!,
          details: detailsController.text.trim(),
        );
      } else {
        await storage.addLecture(
          courseId: widget.courseId,
          title: titleController.text.trim(),
          date: selectedDate!,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${isAssignment ? "Assignment" : "Lecture"} added successfully",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding item: $e")),
      );
    }
  }
}
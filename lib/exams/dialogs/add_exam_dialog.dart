import 'package:flutter/material.dart';
import 'package:edumate/home_page/models/upcoming_exam_item.dart';

Future<UpcomingExamItem?> showAddExamDialog(BuildContext context) {
  return showDialog<UpcomingExamItem>(
    context: context,
    builder: (_) => const _AddExamDialog(),
  );
}

class _AddExamDialog extends StatefulWidget {
  const _AddExamDialog();

  @override
  State<_AddExamDialog> createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<_AddExamDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _syllabusController = TextEditingController();
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  String? _titleError;
  String? _courseError;

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _syllabusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFEFEFEF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add Exam'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Exam Title (e.g. Mid Term, Quiz 1)',
                filled: true,
                fillColor: Colors.white,
                errorText: _titleError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _courseController,
              decoration: InputDecoration(
                labelText: 'Course Name',
                filled: true,
                fillColor: Colors.white,
                errorText: _courseError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _syllabusController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Syllabus / Topics',
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      'Exam Date: ${_formatDate(_selectedDate)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveExam,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final lastDate = DateTime(today.year + 5);
    final initialDate = _selectedDate.isBefore(today)
        ? today
        : (_selectedDate.isAfter(lastDate) ? lastDate : _selectedDate);

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: lastDate,
      initialDate: initialDate,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveExam() {
    final title = _titleController.text.trim();
    final course = _courseController.text.trim();
    final syllabus = _syllabusController.text.trim();

    setState(() {
      _titleError = title.isEmpty ? 'Title required' : null;
      _courseError = course.isEmpty ? 'Course required' : null;
    });

    if (title.isEmpty || course.isEmpty) return;

    Navigator.of(context).pop(
      UpcomingExamItem(
        examTitle: title,
        courseName: course,
        syllabus: syllabus,
        examDate: _selectedDate,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}

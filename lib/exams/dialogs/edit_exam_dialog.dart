import 'package:flutter/material.dart';
import 'package:edumate/home_page/models/upcoming_exam_item.dart';
import 'package:edumate/services/local_storage_service.dart';

Future<UpcomingExamItem?> showEditExamDialog(
  BuildContext context, {
  required UpcomingExamItem initialExam,
}) {
  return showDialog<UpcomingExamItem>(
    context: context,
    builder: (_) => _EditExamDialog(initialExam: initialExam),
  );
}

class _EditExamDialog extends StatefulWidget {
  final UpcomingExamItem initialExam;

  const _EditExamDialog({required this.initialExam});

  @override
  State<_EditExamDialog> createState() => _EditExamDialogState();
}

class _EditExamDialogState extends State<_EditExamDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _courseController;
  late final TextEditingController _syllabusController;
  late DateTime _selectedDate;
  String? _titleError;
  String? _courseError;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialExam.examTitle);
    _courseController =
        TextEditingController(text: widget.initialExam.courseName);
    _syllabusController =
        TextEditingController(text: widget.initialExam.syllabus);
    _selectedDate = widget.initialExam.examDate;
  }

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
      title: const Text('Exam Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Exam Title',
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
          onPressed: () async {
            await LocalStorageService().deleteExam(widget.initialExam.id);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exam Deleted'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
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
      widget.initialExam.copyWith(
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

import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:flutter/material.dart';

Future<TaskItem?> showAddTaskDialog(BuildContext context) {
  return showDialog<TaskItem>(
    context: context,
    builder: (_) => const _AddTaskDialog(),
  );
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); //initialize to current date
  String? _titleError;

  @override
  void dispose() {
    //wipes the info when the dialog box disappears
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFEFEFEF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add Task'),
      content: _buildDialogContent(),
      actions: [
        //cancel btn
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        //save btn
        ElevatedButton(
          onPressed: _saveTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final detail = _detailController.text.trim();

    if(title.isEmpty) {
      setState(() {
        _titleError = 'Title Required!';
      });
      return;
    }

    Navigator.of(context).pop(
        TaskItem(
          title: title,
          detail: detail.isEmpty ? null:detail,
          dueDate: _selectedDate,
        )
    );
  }

  Widget _buildDialogContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitleTextField(),
          const SizedBox(height: 12),
          _buildDetailTextField(),
          const SizedBox(height: 12),
          _buildDatePickerField(),
        ],
      ),
    );
  }


  Widget _buildTitleTextField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Task title',
        filled: true,
        fillColor: Colors.white,
        errorText: _titleError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDetailTextField() {
    return TextField(
      controller: _detailController,
      decoration: InputDecoration(
        labelText: 'Details',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }


  Widget _buildDatePickerField() {
    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 16,),
            SizedBox(width: 10),
            Text(_formatDate(_selectedDate)),
          ],
        )
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      context: context,
      initialDate: _selectedDate,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}

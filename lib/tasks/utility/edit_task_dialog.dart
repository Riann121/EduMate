import 'package:edumate/services/local_storage_service.dart';
import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:flutter/material.dart';

//converts a AlertDialog to TaskItem object and return
Future<TaskItem?> showEditTaskDialog(
  BuildContext context, {
  required TaskItem initialTask,
}) {
  return showDialog<TaskItem>(
    context: context,
    builder: (_) => _EditTaskDialog(initialTask: initialTask),
  );
}

class _EditTaskDialog extends StatefulWidget {
  final TaskItem initialTask;

  const _EditTaskDialog({required this.initialTask});

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _detailController;
  late DateTime _selectedDate;
  String? _titleError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask.title);
    _detailController = TextEditingController(text: widget.initialTask.detail);
    _selectedDate = DateUtils.dateOnly(widget.initialTask.dueDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFEFEFEF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Edit Task'),
      content: _buildDialogContent(),
      actions: [
        TextButton(
          onPressed: () async {
            await LocalStorageService().deleteTask(widget.initialTask.id);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Task Deleted"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red)
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel')
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: Text('Save')
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
          id: widget.initialTask.id,
          title: title,
          detail: detail.isEmpty ? null : detail,
          dueDate: _selectedDate,
          isCompleted: widget.initialTask.isCompleted,
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

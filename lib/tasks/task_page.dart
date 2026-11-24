import 'package:flutter/material.dart';
import 'package:edumate/services/local_storage_service.dart';
import 'package:edumate/tasks/Funtionalities/task_functionalities.dart';
import 'package:edumate/tasks/utility/add_task_dialog.dart';
import 'package:edumate/tasks/utility/edit_task_dialog.dart';
import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:edumate/tasks/widgets/task_tile.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final LocalStorageService _storage = LocalStorageService();
  final TaskFunctionalities func = TaskFunctionalities();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _taskPageAppBar(),
      body: _taskListBody(),
      floatingActionButton: _addTaskButton(),
    );
  }

  AppBar _taskPageAppBar() {
    return AppBar(
      title: const Text('Tasks', style: TextStyle(fontWeight: FontWeight.w900)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(context),
        ),
      ],
    );
  }

  Widget _taskListBody() {
    return ValueListenableBuilder(
      valueListenable: _storage.tasksListenable,
      builder: (context, box, child) {
        final tasks = _storage.getAllTasks();

        if (tasks.isEmpty) {
          return const Center(
            child: Text(
              'No Tasks Left!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TaskTile(
                title: task.title,
                detail: task.detail,
                dueDate: task.dueDate,
                isCompleted: task.isCompleted,
                onTap: () => _onTaskTileTapped(task),
                onChanged: (value) => func.onTaskChecked(task, value),
              ),
            );
          },
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _onAddTaskPressed,
      backgroundColor: Colors.black,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Future<void> _onAddTaskPressed() async {
    final newTask = await showAddTaskDialog(context);
    if (newTask != null) {
      await func.addTask(newTask);
    }
  }

  Future<void> _onTaskTileTapped(TaskItem task) async {
    final updatedTask = await showEditTaskDialog(
      context,
      initialTask: task,
    );

    if (updatedTask != null && mounted) {
      await func.updateTask(task, updatedTask);
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Clear Completed Tasks?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "This will permanently delete all tasks that have been completed.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteAllCompletedTasks();
                      },
                      child: const Text("Delete All"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteAllCompletedTasks() async {
    await _storage.deleteAllCompletedTasks();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Deleted all completed tasks"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}

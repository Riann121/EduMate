import 'package:flutter/material.dart';
import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:edumate/tasks/widgets/task_tile.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<TaskItem> _tasks = buildDummyTaskItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _taskPageAppBar(), body: _taskListBody());
  }

  AppBar _taskPageAppBar() {
    return AppBar(
      title: const Text('Tasks', style: TextStyle(fontWeight: FontWeight.w900)),
      centerTitle: true,
    );
  }

  Widget _taskListBody() {
    if (_tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks left',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TaskTile(
            title: task.title,
            detail: task.detail,
            dueDate: task.dueDate,
            isCompleted: false,
            onChanged: (value) {
              if (value ?? false) {
                setState(() {
                  _tasks.remove(task);
                });
              }
            },
          ),
        );
      },
    );
  }
}

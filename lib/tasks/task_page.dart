import 'package:flutter/material.dart';
import 'package:edumate/tasks/widgets/task_tile.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool _sampleTaskCompleted = false;

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
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      children: [
        TaskTile(
          title: 'Complete DBMS assignment',
          detail: 'CS-302',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          isCompleted: _sampleTaskCompleted,
          onChanged: (value) {
            setState(() {
              _sampleTaskCompleted = value ?? false;
            });
          },
        ),
      ],
    );
  }
}

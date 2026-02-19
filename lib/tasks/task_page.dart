import 'package:edumate/tasks/widgets/add_task_dialog.dart';
import 'package:edumate/tasks/widgets/edit_task_dialog.dart';
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
    );
  }

  //task list
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
            onTap: () => _onTaskTileTapped(index),
            onChanged: (value) {
              if (value == true) {
                setState(() {
                  _tasks.removeAt(index);
                });
              }
            },
          ),
        );
      },
    );
  }

  //add button functionalities
  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _onAddTaskPressed,
      backgroundColor: Colors.black,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Future<void> _onAddTaskPressed() async {
    final newTask = await showAddTaskDialog(context);

    if (newTask == null || !mounted) {
      return;
    }

    setState(() {
      _tasks.add(newTask);
    });
  }

  Future<void> _onTaskTileTapped(int index) async {
    final updatedTask = await showEditTaskDialog(
      context,
      initialTask: _tasks[index],
    );

    if (updatedTask == null || !mounted) {
      return;
    }

    setState(() {
      _tasks[index] = updatedTask;
    });
  }
}

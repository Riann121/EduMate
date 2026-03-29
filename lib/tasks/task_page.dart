import 'package:edumate/tasks/widgets/add_task_dialog.dart';
import 'package:edumate/tasks/widgets/edit_task_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:edumate/tasks/widgets/task_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  // Widget _taskListBody() {
  //   if (_tasks.isEmpty) {
  //     return const Center(
  //       child: Text(
  //         'No tasks left',
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //       ),
  //     );
  //   }
  //
  //   return ListView.builder(
  //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
  //     itemCount: _tasks.length,
  //     itemBuilder: (context, index) {
  //       final task = _tasks[index];
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 10),
  //         child: TaskTile(
  //           title: task.title,
  //           detail: task.detail,
  //           dueDate: task.dueDate,
  //           isCompleted: false,
  //           onTap: () => _onTaskTileTapped(index),
  //           onChanged: (value) {
  //             if (value == true) {
  //               setState(() {
  //                 _tasks.removeAt(index);
  //               });
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _taskListBody() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      // Fetch only tasks belonging to THIS user
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Error loading tasks"));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'No Tasks Left!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700
              )
            )
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            // Firestore data -> TaskItem model
            final task = TaskItem(
              id: docs[index].id,
              title: data['title'] ?? '',
              detail: data['detail'],
              dueDate: (data['dueDate'] as Timestamp).toDate(),
              isCompleted: data['isCompleted'] ?? false,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TaskTile(
                title: task.title,
                detail: task.detail,
                dueDate: task.dueDate,
                isCompleted: task.isCompleted,
                onTap: () => _onTaskTileTapped(task), // Pass the task object directly
                onChanged: (value) {
                  // UPDATE: Change completion status in Firebase
                  docs[index].reference.update({'isCompleted': value});
                },
              ),
            );
          },
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

  Future<void> _onTaskTileTapped(TaskItem task) async {
    final updatedTask = await showEditTaskDialog(
      context,
      initialTask: task,
    );

    if (updatedTask != null) {
      await FirebaseFirestore.instance.collection('tasks').doc(task.id).update({
        'title': updatedTask.title,
        'detail': updatedTask.detail,
        'dueDate': updatedTask.dueDate,
      });
    }
  }
}

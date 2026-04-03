import 'package:edumate/tasks/Funtionalities/task_functionalities.dart';
import 'package:edumate/tasks/utility/add_task_dialog.dart';
import 'package:edumate/tasks/utility/edit_task_dialog.dart';
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
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  TaskFunctionalities func = TaskFunctionalities();

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
                onChanged: (value) => func.onTaskChecked(task, value),
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

    if (newTask != null) {
      func.addTask(newTask, userId);
    }
  }

  Future<void> _onTaskTileTapped(TaskItem task) async {
    // update data
    final updatedTask = await showEditTaskDialog(
      context,
      initialTask: task,
    );

    if (updatedTask != null && mounted) {
      func.updateTask(task, updatedTask);
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
            mainAxisSize: MainAxisSize.min, // Wrap content height
            children: [
              const Text(
                "Clear Completed Tasks?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "This will permanently delete all tasks that has been completed",
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
    if (userId == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No Completed tasks to delete")),
          );
        }
        return;
      }

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Deleted all completed tasks"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }
}

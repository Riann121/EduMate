import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/task_item.dart';

class TaskFunctionalities {
  Future<void> addTask(TaskItem newTask, String? userId) async {
    await FirebaseFirestore.instance.collection('tasks').add({
      'userId': userId,
      'title': newTask.title,
      'detail': newTask.detail,
      'dueDate': newTask.dueDate,
      'isCompleted': false,
    });
  }

  Future<void> updateTask(TaskItem task, TaskItem updatedTask) async {
    await FirebaseFirestore.instance.collection('tasks').doc(task.id).update({
      'title': updatedTask.title,
      'detail': updatedTask.detail,
      'dueDate': updatedTask.dueDate,
    });
  }

  Future<void> deleteTask(TaskItem task) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .doc(task.id)
        .delete();
  }

  void onTaskChecked(TaskItem task, bool? value) {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(task.id)
        .update({'isCompleted': value});
  }
}
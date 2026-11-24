import 'package:edumate/services/local_storage_service.dart';
import '../widgets/task_item.dart';

class TaskFunctionalities {
  final LocalStorageService _storage = LocalStorageService();

  Future<void> addTask(TaskItem newTask, [String? userId]) async {
    await _storage.addTask(newTask);
  }

  Future<void> updateTask(TaskItem task, TaskItem updatedTask) async {
    await _storage.updateTask(task.id, updatedTask);
  }

  Future<void> deleteTask(TaskItem task) async {
    await _storage.deleteTask(task.id);
  }

  void onTaskChecked(TaskItem task, bool? value) {
    _storage.setTaskCompleted(task.id, value);
  }
}
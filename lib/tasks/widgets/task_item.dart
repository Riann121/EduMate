class TaskItem {
  final String id; //for firebase id
  final String title;
  final String? detail;
  final DateTime dueDate;
  final bool isCompleted; //for crud

  const TaskItem({
    this.id = '',
    required this.title,
    this.detail,
    required this.dueDate,
    this.isCompleted = false,
  });
}

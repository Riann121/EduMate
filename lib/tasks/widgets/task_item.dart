class TaskItem {
  final String title;
  final String? detail;
  final DateTime dueDate;

  const TaskItem({
    required this.title,
    this.detail,
    required this.dueDate,
  });
}

List<TaskItem> buildDummyTaskItems() {
  final now = DateTime.now();
  return [
    TaskItem(
      title: 'DLD Assignment',
      detail: 'Complete chapter 5 exercises',
      dueDate: now,
    ),
    TaskItem(
      title: 'DS Assignment',
      detail: 'Complete Binary Search Tree',
      dueDate: now,
    ),
    TaskItem(
      title: 'Math Assignment',
      detail: 'Complete chapter 5 exercises',
      dueDate: now.add(const Duration(days: 1)),
    ),
    TaskItem(
      title: 'Submit EduMate Draft',
      detail: 'Push the latest Dart changes to GitHub',
      dueDate: now.add(const Duration(days: 3)),
    ),

    TaskItem(
      title: 'Biology Report',
      detail: 'Research DNA replication',
      dueDate: now.add(const Duration(days: 4)),
    ),
    TaskItem(
      title: 'History Essay',
      detail: 'Industrial Revolution topic',
      dueDate: now.add(const Duration(days: 5)),
    ),
  ];
}

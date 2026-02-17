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
      title: 'Complete DBMS assignment',
      detail: 'CS-302',
      dueDate: now.add(const Duration(days: 1)),
    ),
    TaskItem(
      title: 'Revise calculus chapter 5',
      detail: 'MTH-201',
      dueDate: now,
    ),
    TaskItem(
      title: 'Submit networking lab report',
      detail: 'CSE-218',
      dueDate: now.add(const Duration(days: 2)),
    ),
    TaskItem(
      title: 'Prepare AI quiz notes',
      detail: 'CSE-340',
      dueDate: now.add(const Duration(days: 3)),
    ),
    TaskItem(
      title: 'Team meeting for mini project',
      detail: 'Project Group B',
      dueDate: now.add(const Duration(days: 4)),
    ),
  ];
}

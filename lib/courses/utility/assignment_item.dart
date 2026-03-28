class AssignmentItem {
  final String title;
  final String dueDate;
  final String details;

  const AssignmentItem({
    required this.title,
    required this.dueDate,
    required this.details,
  });
}

List<AssignmentItem> buildDummyAssignmentItems() {
  final now = DateTime.now();
  return [
    AssignmentItem(
      title: 'Math Assignment',
      dueDate: '2026-03-30',
      details: 'Complete chapter 5 exercises and submit PDF.',
    ),
    AssignmentItem(
      title: 'Biology Report',
      dueDate: '2026-04-01',
      details: 'Write a report on DNA replication.',
    ),
    AssignmentItem(
      title: 'Chemistry Lab',
      dueDate: '2026-04-06',
      details: 'Submit lab observation and calculations.',
    ),
    AssignmentItem(
      title: 'History Essay',
      dueDate: '2026-04-15',
      details: 'Write 1000 words on the Industrial Revolution.',
    ),
  ];
}
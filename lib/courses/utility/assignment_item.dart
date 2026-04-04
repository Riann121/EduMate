class AssignmentItem {
  final String id;
  final String title;
  final DateTime dueDate;
  final String details;

  AssignmentItem({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.details,
  });
}

String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}

List<AssignmentItem> buildDummyAssignmentItems() {
  final now = DateTime.now();
  return [
    AssignmentItem(
      title: 'Math Assignment',
      dueDate: DateTime(2026,3,30),
      details: 'Complete chapter 5 exercises and submit PDF.', id: '',
    ),
    AssignmentItem(
      title: 'Biology Report',
      dueDate: DateTime(2026,04,01),
      details: 'Write a report on DNA replication.', id: '',
    ),
    AssignmentItem(
      title: 'Chemistry Lab',
      dueDate: DateTime(2026,04,10),
      details: 'Submit lab observation and calculations.', id: '',
    ),
    AssignmentItem(
      title: 'History Essay',
      dueDate: DateTime(2026,04,15),
      details: 'Write 1000 words on the Industrial Revolution.', id: '',
    ),
  ];
}
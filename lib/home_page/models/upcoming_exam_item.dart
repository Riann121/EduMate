class UpcomingExamItem {
  final String id;
  final String examTitle;
  final String courseName;
  final String syllabus;
  final DateTime examDate;

  const UpcomingExamItem({
    this.id = '',
    required this.examTitle,
    required this.courseName,
    required this.syllabus,
    required this.examDate,
  });

  UpcomingExamItem copyWith({
    String? id,
    String? examTitle,
    String? courseName,
    String? syllabus,
    DateTime? examDate,
  }) {
    return UpcomingExamItem(
      id: id ?? this.id,
      examTitle: examTitle ?? this.examTitle,
      courseName: courseName ?? this.courseName,
      syllabus: syllabus ?? this.syllabus,
      examDate: examDate ?? this.examDate,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'examTitle': examTitle,
        'courseName': courseName,
        'syllabus': syllabus,
        'examDate': examDate.toIso8601String(),
      };

  factory UpcomingExamItem.fromMap(Map<dynamic, dynamic> map, String id) {
    return UpcomingExamItem(
      id: id,
      examTitle: map['examTitle']?.toString() ?? '',
      courseName: map['courseName']?.toString() ?? '',
      syllabus: map['syllabus']?.toString() ?? '',
      examDate: map['examDate'] != null
          ? DateTime.parse(map['examDate'].toString())
          : DateTime.now(),
    );
  }
}

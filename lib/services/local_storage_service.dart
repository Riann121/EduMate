import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:edumate/courses/utility/assignment_item.dart';
import 'package:edumate/courses/utility/lecture_item.dart';
import 'package:edumate/home_page/models/upcoming_exam_item.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _tasksBoxName = 'tasks_box';
  static const String _routineBoxName = 'routine_box';
  static const String _coursesBoxName = 'courses_box';
  static const String _assignmentsBoxName = 'assignments_box';
  static const String _lecturesBoxName = 'lectures_box';
  static const String _examsBoxName = 'exams_box';

  late Box _tasksBox;
  late Box _routineBox;
  late Box _coursesBox;
  late Box _assignmentsBox;
  late Box _lecturesBox;
  late Box _examsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _tasksBox = await Hive.openBox(_tasksBoxName);
    _routineBox = await Hive.openBox(_routineBoxName);
    _coursesBox = await Hive.openBox(_coursesBoxName);
    _assignmentsBox = await Hive.openBox(_assignmentsBoxName);
    _lecturesBox = await Hive.openBox(_lecturesBoxName);
    _examsBox = await Hive.openBox(_examsBoxName);

    // Evict previously seeded sample exams if they remain in local Hive storage.
    for (final legacyId in const ['dummy_quiz_1', 'dummy_mid_1', 'dummy_viva_1']) {
      if (_examsBox.containsKey(legacyId)) {
        await _examsBox.delete(legacyId);
      }
    }
  }

  // ---------------- TASKS ----------------
  ValueListenable<Box> get tasksListenable => _tasksBox.listenable();

  List<TaskItem> getAllTasks() {
    return _tasksBox.values.map((val) {
      final map = Map<String, dynamic>.from(val as Map);
      return TaskItem(
        id: map['id']?.toString() ?? '',
        title: map['title']?.toString() ?? '',
        detail: map['detail']?.toString(),
        dueDate: map['dueDate'] != null
            ? DateTime.parse(map['dueDate'].toString())
            : DateTime.now(),
        isCompleted: map['isCompleted'] == true,
      );
    }).toList();
  }

  List<TaskItem> getTodayTasks() {
    final now = DateTime.now();
    return getAllTasks().where((task) {
      return task.dueDate.year == now.year &&
          task.dueDate.month == now.month &&
          task.dueDate.day == now.day;
    }).toList();
  }

  Future<void> addTask(TaskItem task) async {
    final id = task.id.isNotEmpty
        ? task.id
        : DateTime.now().millisecondsSinceEpoch.toString();

    await _tasksBox.put(id, {
      'id': id,
      'title': task.title,
      'detail': task.detail,
      'dueDate': task.dueDate.toIso8601String(),
      'isCompleted': false,
    });
  }

  Future<void> updateTask(String id, TaskItem updatedTask) async {
    final existing = _tasksBox.get(id);
    final isCompleted = existing != null && existing is Map
        ? existing['isCompleted'] == true
        : false;

    await _tasksBox.put(id, {
      'id': id,
      'title': updatedTask.title,
      'detail': updatedTask.detail,
      'dueDate': updatedTask.dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    });
  }

  Future<void> setTaskCompleted(String id, bool? isCompleted) async {
    final existing = _tasksBox.get(id);
    if (existing != null && existing is Map) {
      final updated = Map<String, dynamic>.from(existing);
      updated['isCompleted'] = isCompleted ?? false;
      await _tasksBox.put(id, updated);
    }
  }

  Future<void> deleteTask(String id) async {
    await _tasksBox.delete(id);
  }

  Future<void> deleteAllCompletedTasks() async {
    final keysToDelete = <dynamic>[];
    for (final key in _tasksBox.keys) {
      final val = _tasksBox.get(key);
      if (val is Map && val['isCompleted'] == true) {
        keysToDelete.add(key);
      }
    }
    await _tasksBox.deleteAll(keysToDelete);
  }

  // ---------------- ROUTINE ----------------
  ValueListenable<Box> get routineListenable => _routineBox.listenable();

  Map<String, dynamic>? getRoutine() {
    final data = _routineBox.get('current_routine');
    if (data == null) return null;
    return Map<String, dynamic>.from(data as Map);
  }

  Future<void> saveRoutine({
    required String startTime,
    required String duration,
    required String numClasses,
    required String numDays,
    required Map<String, String> routineData,
  }) async {
    await _routineBox.put('current_routine', {
      'startTime': startTime,
      'duration': duration,
      'numClasses': numClasses,
      'numDays': numDays,
      'routineData': routineData,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // ---------------- COURSES ----------------
  ValueListenable<Box> get coursesListenable => _coursesBox.listenable();

  List<Map<String, dynamic>> getAllCourses() {
    return _coursesBox.values.map((val) {
      return Map<String, dynamic>.from(val as Map);
    }).toList();
  }

  Future<String> addCourse({
    required String name,
    required String instructor,
    required String overview,
    required bool isTheory,
  }) async {
    for (final val in _coursesBox.values) {
      if (val is Map && val['name'] == name) {
        return val['id'].toString();
      }
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _coursesBox.put(id, {
      'id': id,
      'name': name,
      'instructor': instructor,
      'overview': overview,
      'isTheory': isTheory,
      'createdAt': DateTime.now().toIso8601String(),
    });
    return id;
  }

  Future<void> deleteCourse(String courseId) async {
    await _coursesBox.delete(courseId);

    final assignmentKeys = _assignmentsBox.keys.where((k) {
      final val = _assignmentsBox.get(k);
      return val is Map && val['courseId'] == courseId;
    }).toList();
    await _assignmentsBox.deleteAll(assignmentKeys);

    final lectureKeys = _lecturesBox.keys.where((k) {
      final val = _lecturesBox.get(k);
      return val is Map && val['courseId'] == courseId;
    }).toList();
    await _lecturesBox.deleteAll(lectureKeys);
  }

  // ---------------- ASSIGNMENTS ----------------
  ValueListenable<Box> get assignmentsListenable => _assignmentsBox.listenable();

  List<AssignmentItem> getAssignmentsForCourse(String courseId) {
    return _assignmentsBox.values
        .where((val) => val is Map && val['courseId'] == courseId)
        .map((val) {
      final map = Map<String, dynamic>.from(val as Map);
      return AssignmentItem(
        id: map['id']?.toString() ?? '',
        title: map['title']?.toString() ?? '',
        dueDate: map['date'] != null
            ? DateTime.parse(map['date'].toString())
            : DateTime.now(),
        details: map['details']?.toString() ?? '',
      );
    }).toList();
  }

  List<AssignmentItem> getAllAssignments() {
    return _assignmentsBox.values.map((val) {
      final map = Map<String, dynamic>.from(val as Map);
      return AssignmentItem(
        id: map['id']?.toString() ?? '',
        title: map['title']?.toString() ?? '',
        dueDate: map['date'] != null
            ? DateTime.parse(map['date'].toString())
            : DateTime.now(),
        details: map['details']?.toString() ?? '',
      );
    }).toList();
  }

  Future<void> addAssignment({
    required String courseId,
    required String title,
    required DateTime date,
    required String details,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _assignmentsBox.put(id, {
      'id': id,
      'courseId': courseId,
      'title': title,
      'date': date.toIso8601String(),
      'details': details,
    });
  }

  Future<void> deleteAssignment(String id) async {
    await _assignmentsBox.delete(id);
  }

  // ---------------- LECTURES ----------------
  ValueListenable<Box> get lecturesListenable => _lecturesBox.listenable();

  List<LectureItem> getLecturesForCourse(String courseId) {
    return _lecturesBox.values
        .where((val) => val is Map && val['courseId'] == courseId)
        .map((val) {
      final map = Map<String, dynamic>.from(val as Map);
      return LectureItem(
        id: map['id']?.toString() ?? '',
        title: map['title']?.toString() ?? '',
        date: map['date'] != null
            ? DateTime.parse(map['date'].toString())
            : DateTime.now(),
      );
    }).toList();
  }

  Future<void> addLecture({
    required String courseId,
    required String title,
    required DateTime date,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _lecturesBox.put(id, {
      'id': id,
      'courseId': courseId,
      'title': title,
      'date': date.toIso8601String(),
    });
  }

  Future<void> deleteLecture(String id) async {
    await _lecturesBox.delete(id);
  }

  // ---------------- EXAMS ----------------
  ValueListenable<Box> get examsListenable => _examsBox.listenable();

  List<UpcomingExamItem> getAllExams() {
    final list = _examsBox.values.map((val) {
      final map = Map<String, dynamic>.from(val as Map);
      return UpcomingExamItem.fromMap(map, map['id']?.toString() ?? '');
    }).toList();

    list.sort((a, b) => a.examDate.compareTo(b.examDate));
    return list;
  }

  List<UpcomingExamItem> getUpcomingExamsThisWeek() {
    final today = DateUtils.dateOnly(DateTime.now());
    final weekEnd = today.add(const Duration(days: 6));

    return getAllExams().where((item) {
      final dateOnly = DateUtils.dateOnly(item.examDate);
      return !dateOnly.isBefore(today) && !dateOnly.isAfter(weekEnd);
    }).toList();
  }

  Future<void> addExam(UpcomingExamItem exam) async {
    final id = exam.id.isNotEmpty
        ? exam.id
        : DateTime.now().millisecondsSinceEpoch.toString();

    final itemWithId = exam.copyWith(id: id);
    await _examsBox.put(id, itemWithId.toMap());
  }

  Future<void> updateExam(String id, UpcomingExamItem exam) async {
    final itemWithId = exam.copyWith(id: id);
    await _examsBox.put(id, itemWithId.toMap());
  }

  Future<void> deleteExam(String id) async {
    await _examsBox.delete(id);
  }
}

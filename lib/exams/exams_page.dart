import 'package:flutter/material.dart';
import 'package:edumate/services/local_storage_service.dart';
import 'package:edumate/exams/widgets/exam_tile.dart';
import 'package:edumate/exams/dialogs/add_exam_dialog.dart';
import 'package:edumate/exams/dialogs/edit_exam_dialog.dart';
import 'package:edumate/home_page/models/upcoming_exam_item.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  final LocalStorageService _storage = LocalStorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Exams', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: _storage.examsListenable,
        builder: (context, box, child) {
          final exams = _storage.getAllExams();

          if (exams.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Exams Scheduled',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add an upcoming exam',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              return ExamTile(
                exam: exam,
                onTap: () => _onExamTapped(exam),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddExamPressed,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _onAddExamPressed() async {
    final newExam = await showAddExamDialog(context);
    if (newExam != null) {
      await _storage.addExam(newExam);
    }
  }

  Future<void> _onExamTapped(UpcomingExamItem exam) async {
    final updatedExam = await showEditExamDialog(context, initialExam: exam);
    if (updatedExam != null) {
      await _storage.updateExam(exam.id, updatedExam);
    }
  }
}

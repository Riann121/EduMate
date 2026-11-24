import 'package:flutter/material.dart';
import 'package:edumate/courses/courses_page.dart';
import 'package:edumate/theme/app_theme.dart';
import 'package:edumate/home_page/home_page.dart';
import 'package:edumate/routine/routine_page.dart';
import 'package:edumate/tasks/task_page.dart';
import 'package:edumate/exams/exams_page.dart';
import 'package:edumate/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduMate',
      theme: AppTheme().AppThemeData(),
      home: const HomePage(),
      routes: {
        '/courses': (context) => const CoursesPage(),
        '/routine': (context) => const RoutinePage(),
        '/tasks': (context) => const TaskPage(),
        '/exams': (context) => const ExamsPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

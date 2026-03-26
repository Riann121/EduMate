import 'package:flutter/material.dart';
import 'package:edumate/courses/courses_page.dart';
import 'package:edumate/theme/app_theme.dart';
import 'package:edumate/home_page/home_page.dart';
import 'package:edumate/routine/routine_page.dart';
import 'package:edumate/tasks/task_page.dart';
import 'package:edumate/login&registration/login_page/login_page.dart';
import 'package:edumate/login&registration/registration_page/registration_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edumate',
      theme: AppTheme().AppThemeData(),
      home: const HomePage(),
      routes: {
        '/courses': (context) => const CoursesPage(),
        '/routine': (context) => const RoutinePage(),
        '/tasks': (context) => const TaskPage(),
      },
    );
  }
}

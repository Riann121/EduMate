import 'package:edumate/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/assignment_item.dart';
import 'package:edumate/courses/utility/assignment_tile.dart';


class CourseTemplatePage extends StatelessWidget {
  final String courseName;
  final String instructorName;
  final String overview;
  final List<AssignmentItem> assignments;
  final List<LectureItem> lectures;

  const CourseTemplatePage({
    super.key,
    required this.courseName,
    required this.instructorName,
    required this.overview,
    required this.assignments,
    required this.lectures,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: Text(
          courseName,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // =================Overview section=================
              _titleText("Overview"),
              Card(
                color: AppColors.surface,
                elevation: 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    overview,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =================Assignment section=================
              _titleText("Upcoming Assignments"),
              ...assignments.map((a) => AssignmentCard(assignment: a)),

              const SizedBox(height: 20),

              // =================Lectures section=================
              _titleText("Due lectures"),
              ...lectures.map((l) => _lectureCard(l)),
            ],
          ),
        ),
      ),
    );
  }
//text widget to display title
  Widget _titleText(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


//cards for lectures
  Widget _lectureCard(LectureItem lecture) {
    return Card(
      color: Color(0xFFF4F7FF),
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.library_books_outlined, color: Colors.black),
        title: Text(
          lecture.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(lecture.date),
      ),
    );
  }
}


class LectureItem {
  final String title;
  final String date;

  const LectureItem({
    required this.title,
    required this.date,
  });
}
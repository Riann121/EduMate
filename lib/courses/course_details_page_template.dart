import 'package:edumate/courses/utility/lecture_tile.dart';
import 'package:edumate/courses/utility/lecture_details_page.dart';
import 'package:edumate/courses/utility/lecture_item.dart';
import 'package:edumate/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/assignment_item.dart';
import 'package:edumate/courses/utility/assignment_tile.dart';
import 'package:edumate/courses/utility/add_item_dialog.dart';
import 'package:edumate/courses/utility/assignment_details_page.dart';

class CourseTemplatePage extends StatefulWidget {
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
  State<CourseTemplatePage> createState() => _CourseTemplatePageState();
}

class _CourseTemplatePageState extends State<CourseTemplatePage> {
  late List<AssignmentItem> assignments;
  late List<LectureItem> lectures;

  @override
  void initState() {
    super.initState();
    assignments = List.from(widget.assignments);
    lectures = List.from(widget.lectures);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.courseName,
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
                    widget.overview,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =================Assignment section=================
              _titleText("Upcoming Assignments"),
              ...assignments.map(
                (a) => AssignmentCard(
                  assignment: a,
                  onTap: () {
                    showAssignmentDetails(
                      context: context,
                      assignment: a,
                      onUpdate: () {
                        setState(() {});
                      },
                      onDelete: () {
                        setState(() {
                          assignments.remove(a);
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // =================Lectures section=================
              _titleText("Upcoming Lectures"),
              ...lectures.map(
                (l) => LectureCard(
                  lecture: l,
                  onTap: () {
                    showLectureDetails(
                      context: context,
                      lecture: l,
                      onDelete: () => setState(() => lectures.remove(l)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddItemDialog(
            context: context,
            onAddAssignment: (assignment) {
              setState(() => assignments.add(assignment));
            },
            onAddLecture: (lecture) {
              setState(() => lectures.add(lecture));
            },
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  //text widget to display title
  Widget _titleText(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

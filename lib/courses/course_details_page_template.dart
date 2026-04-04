import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:edumate/courses/utility/assignment_item.dart';
import 'package:edumate/courses/utility/lecture_item.dart';
import 'package:edumate/courses/utility/assignment_tile.dart';
import 'package:edumate/courses/utility/lecture_tile.dart';
import 'package:edumate/courses/utility/assignment_details_page.dart';
import 'package:edumate/courses/utility/lecture_details_page.dart';
import 'package:edumate/courses/utility/add_item_dialog.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String courseCode;
  final String overview;
  final String instructorName;

  const CourseDetailPage({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.overview,
    required this.instructorName,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.courseName,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.courseCode.isNotEmpty)
              Text(
                widget.courseCode,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
      ),

      body: Column(
        children: [
          //Overview
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Overview",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.overview,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          const Divider(height: 1),

          // Tabs
          Container(
            color: Colors.grey[100],
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: "Assignments"),
                Tab(text: "Lectures"),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildAssignmentsTab(), _buildLecturesTab()],
            ),
          ),
        ],
      ),

      // Floating Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showAddItemDialog(context: context, courseId: widget.courseId);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ================= ASSIGNMENTS =================
  Widget _buildAssignmentsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .collection('assignments')
          .orderBy('date', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _emptyState(
            icon: Icons.assignment_outlined,
            title: "No assignments yet",
            subtitle: "Tap + to add an assignment",
          );
        }

        final assignments = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return AssignmentItem(
            id: doc.id,
            title: data['title'] ?? '',
            dueDate: (data['date'] as Timestamp).toDate(),
            details: data['details'] ?? '',
          );
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            return AssignmentCard(
              assignment: assignment,
              onTap: () {
                showAssignmentDetails(
                  context: context,
                  assignment: assignment,
                  onUpdate: () {},
                  onDelete: () => _deleteAssignment(assignment.id),
                );
              },
            );
          },
        );
      },
    );
  }

  // ================= LECTURES =================
  Widget _buildLecturesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .collection('lectures')
          .orderBy('date', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _emptyState(
            icon: Icons.library_books_outlined,
            title: "No lectures yet",
            subtitle: "Tap + to add a lecture",
          );
        }

        final lectures = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return LectureItem(
            id: doc.id,
            title: data['title'] ?? '',
            date: (data['date'] as Timestamp).toDate(),
          );
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: lectures.length,
          itemBuilder: (context, index) {
            final lecture = lectures[index];
            return LectureCard(
              lecture: lecture,
              onTap: () {
                showLectureDetails(
                  context: context,
                  lecture: lecture,
                  onDelete: () => _deleteLecture(lecture.id),
                );
              },
            );
          },
        );
      },
    );
  }

  // ================= EMPTY STATE =================
  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // ================= DELETE FUNCTIONS =================
  Future<void> _deleteAssignment(String id) async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .collection('assignments')
        .doc(id)
        .delete();
  }

  Future<void> _deleteLecture(String id) async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .collection('lectures')
        .doc(id)
        .delete();
  }
}

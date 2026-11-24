import 'package:flutter/material.dart';
import 'package:edumate/services/local_storage_service.dart';
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
  final LocalStorageService _storage = LocalStorageService();

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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: 'Delete Course',
            onPressed: _confirmDeleteCourse,
          ),
        ],
      ),
      body: Column(
        children: [
          // Overview
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Overview",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _confirmDeleteCourse,
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      label: const Text(
                        "Delete Course",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.instructorName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    "Instructor: ${widget.instructorName}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
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
    return ValueListenableBuilder(
      valueListenable: _storage.assignmentsListenable,
      builder: (context, box, child) {
        final assignments = _storage.getAssignmentsForCourse(widget.courseId);

        if (assignments.isEmpty) {
          return _emptyState(
            icon: Icons.assignment_outlined,
            title: "No assignments yet",
            subtitle: "Tap + to add an assignment",
          );
        }

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
                  onUpdate: () => setState(() {}),
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
    return ValueListenableBuilder(
      valueListenable: _storage.lecturesListenable,
      builder: (context, box, child) {
        final lectures = _storage.getLecturesForCourse(widget.courseId);

        if (lectures.isEmpty) {
          return _emptyState(
            icon: Icons.library_books_outlined,
            title: "No lectures yet",
            subtitle: "Tap + to add a lecture",
          );
        }

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

  Future<void> _deleteAssignment(String id) async {
    await _storage.deleteAssignment(id);
  }

  Future<void> _deleteLecture(String id) async {
    await _storage.deleteLecture(id);
  }

  Future<void> _confirmDeleteCourse() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Course'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${widget.courseName}"? All associated assignments and lectures will also be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await _storage.deleteCourse(widget.courseId);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Course "${widget.courseName}" deleted'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}

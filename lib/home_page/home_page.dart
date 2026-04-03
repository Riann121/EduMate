import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edumate/tasks/Funtionalities/task_functionalities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edumate/home_page/widgets/home_stats_grid.dart';
import 'package:edumate/home_page/widgets/upcoming_exams_section.dart';
import 'package:edumate/tasks/utility/edit_task_dialog.dart';
import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:edumate/tasks/widgets/task_tile.dart';
import 'package:edumate/tasks/task_page.dart';
import 'package:edumate/courses/utility/assignment_item.dart';
import 'package:edumate/courses/utility/assignment_tile.dart';
import 'package:edumate/courses/utility/assignment_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<AssignmentItem> _upcomingAssignments;
  TaskFunctionalities taskFunc = TaskFunctionalities();

  @override
  void initState() {
    super.initState();

    //fetching this week's exams
    _upcomingAssignments = buildDummyAssignmentItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _homePageAppBar(),
      drawer: _drawerWidget(),
      body: _bodyWidget(),
    );
  }

  AppBar _homePageAppBar() {
    return AppBar(
      title: const Text(
        'EduMate',
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
          icon: Icon(Icons.logout)
        )
      ],
    );
  }

  Drawer _drawerWidget() {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _drawerHeader(),
          _tasksTile(),
          _routineTile(),
          _coursesTile(),
        ],
      ),
    );
  }

  DrawerHeader _drawerHeader() {
    return DrawerHeader(
      child: Center(
        child: Image.asset(
          'assets/logos/edumate_logo.png',
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  ListTile _tasksTile() {
    return ListTile(
      leading: Icon(Icons.task_alt),
      title: Text('Tasks', style: TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/tasks');
      },
    );
  }

  ListTile _routineTile() {
    return ListTile(
      leading: Icon(Icons.schedule),
      title: Text('Routine', style: TextStyle(fontWeight: FontWeight.w500),),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/routine');
      },
    );
  }

  ListTile _coursesTile() {
    return ListTile(
      leading: Icon(Icons.menu_book),
      title: Text('Courses', style: TextStyle(fontWeight: FontWeight.w500),),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/courses');
      }
    );
  }

  // ---------- Body Widget ----------
  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          _welcomeTextTitle(),
          const SizedBox(height: 16),
          const HomeStatsGrid(),
          const SizedBox(height: 50),
          _todayTasksSection(),
          const SizedBox(height: 25),
          const UpcomingExamsSection(),
          const SizedBox(height: 25),
          _weeklySubmissionsSection(),
        ],
      ),
    );
  }

  // body title
  Widget _welcomeTextTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: const Text(
        'Welcome Back',
        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
      ),
    );
  }

  // Today's tasks section with title and list of tasks or empty state
  Widget _todayTasksSection() {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: _sectionBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _todayTasksTitle(),
          const SizedBox(height: 18),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // today tasks fetch
              final List<TaskItem> todayTasks = snapshot.data!.docs.where((doc) {
                final date = (doc['dueDate'] as Timestamp).toDate();
                return DateUtils.isSameDay(date, DateTime.now());
              }).map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return TaskItem(
                  id: doc.id,
                  title: data['title'] ?? '',
                  detail: data['detail'],
                  dueDate: (data['dueDate'] as Timestamp).toDate(),
                  isCompleted: data['isCompleted'] ?? false,
                );
              }).toList();

              if (todayTasks.isEmpty) {
                return _todayTasksEmptyState();
              }


              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todayTasks.length,
                itemBuilder: (context, index) {
                  final task = todayTasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TaskTile(
                      title: task.title,
                      detail: task.detail,
                      dueDate: task.dueDate,
                      isCompleted: task.isCompleted,
                      onTap: () => _onTodayTaskTileTapped(task), // edit hover
                      onChanged: (value) => taskFunc.onTaskChecked(task, value), // update
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  BoxDecoration _sectionBoxDecoration() {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    );
  }

  Widget _todayTasksTitle() {
    return Text(
      "Today's Tasks",
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    );
  }


  Widget _todayTasksEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        'No tasks assigned for today',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
  

  Future<void> _onTodayTaskTileTapped(TaskItem task) async {
    //edit data
    final updatedTask = await showEditTaskDialog(
      context,
      initialTask: task,
    );

    if (updatedTask != null && mounted) {
      // update task
      await FirebaseFirestore.instance.collection('tasks').doc(task.id).update({
        'title': updatedTask.title,
        'detail': updatedTask.detail,
        'dueDate': updatedTask.dueDate,
      });
    }
  }

  Future<void> _deleteTodayTask(TaskItem task, bool? value) async {
    if (value == true) {
      // delete
      FirebaseFirestore.instance
          .collection('tasks')
          .doc(task.id)
          .delete();

      // show a message to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task Completed & Removed"),
          backgroundColor: Colors.lightGreen,
        ),
      );
    }
  }

  // ----------- Upcoming assignment section -------------
  Widget _weeklySubmissionsSection() {
    // Fetching the dummy data
    final weeklyAssignments = buildDummyAssignmentItems();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: _sectionBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Submissions",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800
            ),
          ),
          const SizedBox(height: 18),
          if (weeklyAssignments.isEmpty)
            const Text("No submissions due this week")
          else
            ...weeklyAssignments.map((assignment) => AssignmentCard(
              assignment: assignment,
              onTap: () => showAssignmentDetails(
                context: context,
                assignment: assignment,
                onUpdate: () => setState(() {}), // Refresh UI on update
                onDelete: () {
                  setState(() {
                    // Logic to remove from your data source would go here
                  });
                },
              ),
            )),
        ],
      ),
    );
  }
}

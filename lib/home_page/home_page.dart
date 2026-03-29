import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edumate/home_page/widgets/home_stats_grid.dart';
import 'package:edumate/home_page/widgets/upcoming_exams_section.dart';
import 'package:edumate/tasks/widgets/edit_task_dialog.dart';
import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:edumate/tasks/widgets/task_tile.dart';
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

  // ---------- AppBar Widget ----------
  // AppBar _homePageAppBar() {
  //   return AppBar(
  //     title: const Text(
  //       'EduMate',
  //       style: TextStyle(fontWeight: FontWeight.w900),
  //     ),
  //     centerTitle: true,
  //   );
  // }
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

  // ---------- Drawer Widget ----------
  // Drawer _drawerWidget() {
  //   return Drawer(
  //     backgroundColor: Theme.of(context).colorScheme.surface,
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         _drawerHeader(),
  //         _tasksTile(),
  //         _routineTile(),
  //         _coursesTile(),
  //       ],
  //     ),
  //   );
  // }

  // Drawer Header with logo and error handling for image loading
  // DrawerHeader _drawerHeader() {
  //   return DrawerHeader(
  //     child: Center(
  //       child: Image.asset(
  //         'assets/logos/edumate_logo.png',
  //         width: 80,
  //         height: 80,
  //         fit: BoxFit.contain,
  //         errorBuilder: (context, error, stackTrace) {
  //           return Icon(
  //             Icons.broken_image_outlined,
  //             size: 80,
  //             color: Theme.of(context).colorScheme.primary,
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
  //
  // //tiles for navigation in drawer
  // ListTile _coursesTile() {
  //   return _drawerNavigationTile(
  //     title: 'Courses',
  //     icon: Icons.menu_book_outlined,
  //     routeName: '/courses',
  //   );
  // }
  //
  // ListTile _routineTile() {
  //   return _drawerNavigationTile(
  //     title: 'Routine',
  //     icon: Icons.schedule_outlined,
  //     routeName: '/routine',
  //   );
  // }
  //
  // ListTile _tasksTile() {
  //   return _drawerNavigationTile(
  //     title: 'Tasks',
  //     icon: Icons.task_alt_outlined,
  //     routeName: '/tasks',
  //   );
  // }
  //
  // //method to create drawer navigation tiles
  // ListTile _drawerNavigationTile({
  //   required String title,
  //   required IconData icon,
  //   required String routeName,
  // }) {
  //   return ListTile(
  //     leading: Icon(icon),
  //     title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
  //     onTap: () {
  //       Navigator.pop(context);
  //       Navigator.pushNamed(context, routeName);
  //     },
  //   );
  // }

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
                  id: doc.id, // CRITICAL: Pass the Firestore ID here
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
                      onChanged: (value) => _onTodayTaskChecked(task, value), // update
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


  void _onTodayTaskChecked(TaskItem task, bool? value) {
    // update data
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(task.id)
        .update({'isCompleted': value});
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

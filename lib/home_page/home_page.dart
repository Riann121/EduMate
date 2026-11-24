import 'package:flutter/material.dart';
import 'package:edumate/services/local_storage_service.dart';
import 'package:edumate/tasks/Funtionalities/task_functionalities.dart';
import 'package:edumate/home_page/widgets/home_stats_grid.dart';
import 'package:edumate/home_page/widgets/upcoming_exams_section.dart';
import 'package:edumate/tasks/utility/edit_task_dialog.dart';
import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:edumate/tasks/widgets/task_tile.dart';
import 'package:edumate/courses/utility/assignment_tile.dart';
import 'package:edumate/courses/utility/assignment_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorageService _storage = LocalStorageService();
  final TaskFunctionalities _taskFunc = TaskFunctionalities();

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
          _examsTile(),
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
      leading: const Icon(Icons.task_alt),
      title: const Text('Tasks', style: TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/tasks');
      },
    );
  }

  ListTile _routineTile() {
    return ListTile(
      leading: const Icon(Icons.schedule),
      title: const Text('Routine', style: TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/routine');
      },
    );
  }

  ListTile _coursesTile() {
    return ListTile(
      leading: const Icon(Icons.menu_book),
      title: const Text('Courses', style: TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/courses');
      },
    );
  }

  ListTile _examsTile() {
    return ListTile(
      leading: const Icon(Icons.assignment_turned_in_outlined),
      title: const Text('Exams', style: TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/exams');
      },
    );
  }

  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          _welcomeTextTitle(),
          const SizedBox(height: 16),
          const HomeStatsGrid(),
          const SizedBox(height: 30),
          _todayTasksSection(),
          const SizedBox(height: 25),
          const UpcomingExamsSection(),
          const SizedBox(height: 25),
          _weeklySubmissionsSection(),
        ],
      ),
    );
  }

  Widget _welcomeTextTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 12),
      child: Text(
        'Welcome Back',
        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _todayTasksSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: _sectionBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _todayTasksTitle(),
          const SizedBox(height: 18),
          ValueListenableBuilder(
            valueListenable: _storage.tasksListenable,
            builder: (context, box, child) {
              final todayTasks = _storage.getTodayTasks();

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
                      onTap: () => _onTodayTaskTileTapped(task),
                      onChanged: (value) => _taskFunc.onTaskChecked(task, value),
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
    final updatedTask = await showEditTaskDialog(
      context,
      initialTask: task,
    );

    if (updatedTask != null && mounted) {
      await _taskFunc.updateTask(task, updatedTask);
    }
  }

  Widget _weeklySubmissionsSection() {
    return ValueListenableBuilder(
      valueListenable: _storage.assignmentsListenable,
      builder: (context, box, child) {
        final weeklyAssignments = _storage.getAllAssignments();

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
                  fontWeight: FontWeight.w800,
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
                        onUpdate: () => setState(() {}),
                        onDelete: () async {
                          await _storage.deleteAssignment(assignment.id);
                        },
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }
}

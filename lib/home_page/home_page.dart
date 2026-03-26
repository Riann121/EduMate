import 'package:flutter/material.dart';
import 'package:edumate/home_page/widgets/home_stats_grid.dart';
import 'package:edumate/home_page/widgets/upcoming_exams_section.dart';
import 'package:edumate/home_page/widgets/weekly_submissions_section.dart';
import 'package:edumate/tasks/widgets/edit_task_dialog.dart';
import 'package:edumate/tasks/widgets/task_item.dart';
import 'package:edumate/tasks/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<TaskItem> _todayTasks;

  @override
  void initState() {
    super.initState();
    //fetching today's tasks
    _todayTasks = buildDummyTaskItems()
        .where((task) => DateUtils.isSameDay(task.dueDate, DateTime.now()))
        .toList();
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
          const WeeklySubmissionsSection(),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: _sectionBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _todayTasksTitle(),
          const SizedBox(height: 18),
          ..._todayTasksContent(), //spreads the list of widgets into the children of the column
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

  List<Widget> _todayTasksContent() {
    if (_todayTasks.isEmpty) {
      return [_todayTasksEmptyState()];
    }

    return _todayTasks
        .asMap()
        .entries
        .map((entry) {
          return _todayTaskTile(index: entry.key, task: entry.value);
        })
        .toList(growable: false);
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

  Widget _todayTaskTile({required int index, required TaskItem task}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TaskTile(
        title: task.title,
        detail: task.detail,
        dueDate: task.dueDate,
        isCompleted: false,
        onTap: () => _onTodayTaskTileTapped(index),
        onChanged: (value) => _onTodayTaskChecked(value, index),
      ),
    );
  }

  void _onTodayTaskChecked(bool? value, int index) {
    if (value == true) {
      setState(() {
        _todayTasks.removeAt(index);
      });
    }
  }

  Future<void> _onTodayTaskTileTapped(int index) async {
    final updatedTask = await showEditTaskDialog(
      context,
      initialTask: _todayTasks[index],
    );

    if (updatedTask == null || !mounted) {
      return;
    }

    setState(() {
      if (DateUtils.isSameDay(updatedTask.dueDate, DateTime.now())) {
        _todayTasks[index] = updatedTask;
      } else {
        _todayTasks.removeAt(index);
      }
    });
  }
}

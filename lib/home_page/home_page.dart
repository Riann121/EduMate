import 'package:flutter/material.dart';
import 'package:edumate/home_page/widgets/home_stats_grid.dart';
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
  AppBar _homePageAppBar() {
    return AppBar(
      title: const Text(
        'Edumate',
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
      centerTitle: true,
    );
  }

  // ---------- Drawer Widget ----------
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

  // Drawer Header with logo and error handling for image loading
  DrawerHeader _drawerHeader() {
    return DrawerHeader(
      child: Center(
        child: Image.asset(
          'assets/logos/edumate_logo.png',
          width: 80,
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.broken_image_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ),
    );
  }

  //tiles for navigation in drawer
  ListTile _coursesTile() {
    return _drawerNavigationTile(
      title: 'Courses',
      icon: Icons.menu_book_outlined,
      routeName: '/courses',
    );
  }

  ListTile _routineTile() {
    return _drawerNavigationTile(
      title: 'Routine',
      icon: Icons.schedule_outlined,
      routeName: '/routine',
    );
  }

  ListTile _tasksTile() {
    return _drawerNavigationTile(
      title: 'Tasks',
      icon: Icons.task_alt_outlined,
      routeName: '/tasks',
    );
  }

  //method to create drawer navigation tiles
  ListTile _drawerNavigationTile({
    required String title,
    required IconData icon,
    required String routeName,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      },
    );
  }

  // ---------- Body Widget ----------
  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          _bodyTitle(),
          const SizedBox(height: 16),
          const HomeStatsGrid(),
          const SizedBox(height: 50),
          _todayTasksSection(),
        ],
      ),
    );
  }

  // body title
  Widget _bodyTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: const Text(
        'Welcome Back',
        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _todayTasksSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Tasks",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          if (_todayTasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No tasks assigned for today',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            )
          else
            ..._todayTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TaskTile(
                  title: task.title,
                  detail: task.detail,
                  dueDate: task.dueDate,
                  isCompleted: false,
                  onChanged: (value) {
                    if (value == true) {
                      setState(() {
                        _todayTasks.remove(task);
                      });
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

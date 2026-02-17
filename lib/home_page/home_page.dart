import 'package:flutter/material.dart';
import 'package:edumate/home_page/widgets/home_stats_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        style: TextStyle(fontWeight: FontWeight.bold),
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
          SizedBox(height: 12),
          _bodyTitle(),
          SizedBox(height: 12),
          HomeStatsGrid(),
        ],
      ),
    );
  }

  // body title
  Widget _bodyTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Text(
        'Welcome Back',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
      ),
    );
  }
}

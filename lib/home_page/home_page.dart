import 'package:flutter/material.dart';

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


  AppBar _homePageAppBar() {
    return AppBar(
      title: const Text(
        'Edumate',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ), 
      centerTitle: true
    );
  }

  Drawer _drawerWidget() {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return const Center(
      child: Text('Welcome to the Home Page!'),
    );
  }
}

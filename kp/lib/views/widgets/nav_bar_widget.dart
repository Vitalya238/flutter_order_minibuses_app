import 'package:flutter/material.dart';
import 'package:kp/views/view.dart';
import 'package:provider/provider.dart';

import '../../services/database_notifier.dart';
class BottomNavBarExample extends StatefulWidget {
  const BottomNavBarExample({super.key});

  @override
  _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    ChangeNotifierProvider(
      create: (context) => DatabaseNotifier(),
      child: const FindMinibusScreen(),
    ),
    ChangeNotifierProvider(
      create: (context) => DatabaseNotifier(),
      child: HelpScreen(),
    ),
    ChangeNotifierProvider(
      create: (context) => DatabaseNotifier(),
      child: ListOfTripsScreen(),
    ),
    ChangeNotifierProvider(
      create: (context) => DatabaseNotifier(),
      child: ProfileScreen(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.amberAccent,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bus_alert_rounded),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

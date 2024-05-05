import 'package:flutter/material.dart';
import 'package:kp/views/view.dart';
import 'package:provider/provider.dart';

import '../../services/database_notifier.dart';
import '../manage_minibuses_screen.dart';
class BottomNavBarForClients extends StatefulWidget {
  const BottomNavBarForClients({super.key});

  @override
  _BottomNavBarForClientsState createState() => _BottomNavBarForClientsState();
}

class _BottomNavBarForClientsState extends State<BottomNavBarForClients> {
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



class BottomNavBarForDispatchers extends StatefulWidget {
  const BottomNavBarForDispatchers({super.key});

  @override
  _BottomNavBarForDispatchersState createState() => _BottomNavBarForDispatchersState();
}

class _BottomNavBarForDispatchersState extends State<BottomNavBarForDispatchers> {
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
      child: ManageMinibuses(),
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

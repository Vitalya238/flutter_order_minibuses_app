import 'package:flutter/material.dart';
import 'widgets/widget.dart';
class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen>{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Заказ маршрутки'),
      ),
      bottomNavigationBar: const BottomNavBarExample(),
    );
  }
}
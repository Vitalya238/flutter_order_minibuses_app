import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/widget.dart';
import 'package:kp/services/auth_notifier.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
        builder: (context, authNotifier, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              title: const Text('Заказ маршрутки'),
            ),
            bottomNavigationBar: authNotifier.currentUser.roleId == 1
                ? BottomNavBarForDispatchers()
                : BottomNavBarForClients(),
          );
        });
  }
}

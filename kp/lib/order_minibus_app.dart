import 'package:flutter/material.dart';
import 'package:kp/services/auth_notifier.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:provider/provider.dart';
import 'views/view.dart';

class OrderingMinibusesApp extends StatelessWidget {
  const OrderingMinibusesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrderingMinibusesApp',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.amberAccent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthNotifier()),
          ChangeNotifierProvider(create: (context) => DatabaseNotifier()),
        ],
        child: const MainScreen(),
      ),
    );
  }
}
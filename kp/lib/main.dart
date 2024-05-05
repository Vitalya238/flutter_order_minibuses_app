import 'package:flutter/material.dart';
import 'package:kp/order_minibus_app.dart';
import 'package:kp/services/auth_notifier.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthNotifier()),
        ChangeNotifierProvider(create: (context) => DatabaseNotifier()),
      ],
      child: OrderingMinibusesApp(),
    ),
  );
}


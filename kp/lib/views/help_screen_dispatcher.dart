import 'package:flutter/material.dart';

class HelpScreenDispathcer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'SEX',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: const Center(
        child: Text('Help screen'),
      ),
    );
  }
}
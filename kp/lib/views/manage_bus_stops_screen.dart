import 'package:flutter/material.dart';

class ManageBusStops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Sex',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: const Center(
        child: Text('BusStops'),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ListOfTripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Trips',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: const Center(
        child: Text('Trips Screen'),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:kp/views/view.dart';

class ManageDatabase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Manage',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageMinibuses()),
                );
              },
              child: const Text('Manage minibuses'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageBusStops()),
                );
              },
              child: const Text('Manage Bus stops'),
            ),
          ],
        ),
      ),
    );
  }
}

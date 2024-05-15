import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kp/models/Application.dart';
import 'package:kp/models/Client.dart';
import 'package:kp/services/application_handler.dart';
import 'package:kp/services/client_handler.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:provider/provider.dart';

class DriverApplicationList extends StatefulWidget {
  @override
  _DriverApplicationListState createState() => _DriverApplicationListState();
}

class _DriverApplicationListState extends State<DriverApplicationList> {
  late Future<List<DriverApplication>> _driverApplicationsFuture;

  @override
  void initState() {
    super.initState();
    _driverApplicationsFuture = _getAllApplications();
  }

  Future<List<DriverApplication>> _getAllApplications() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    DriverApplicationHandler driverApplicationHandler = DriverApplicationHandler(dbHelper.db);
    return driverApplicationHandler.getAllApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Applications',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<List<DriverApplication>>(
        future: _driverApplicationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<DriverApplication> applications = snapshot.data as List<DriverApplication>;
            return ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('User №${applications[index].userId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Experience: ${applications[index].experience} years'),
                          SizedBox(width: 8),
                          Text('License:'),
                          _showLicenseImage(applications[index].license),
                        ],
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _updateUserRoleAndDeleteApplication(applications[index]),
                            icon: Icon(Icons.arrow_upward),
                            label: Text('Accept'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _deleteApplication(applications[index].id),
                            icon: Icon(Icons.arrow_downward),
                            label: Text('Deny'),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),

                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _showLicenseImage(Uint8List license) {
    if (license.isNotEmpty) {
      return Image.memory(license, height: 100);
    } else {
      return Text('Лицензия отсутствует');
    }
  }

  void _updateUserRoleAndDeleteApplication(DriverApplication application) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    ClientHandler clientHandler = ClientHandler(dbHelper.db);
    DriverApplicationHandler applicationHandler = DriverApplicationHandler(dbHelper.db);

    Client? user = await clientHandler.getClient(application.userId);
    if (user != null) {
      user.roleId = 3;
      await clientHandler.update(user);
      await applicationHandler.delete(application.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Роль пользователя обновлена до 3, заявление удалено'),
      ));
      setState(() {
        _driverApplicationsFuture = _getAllApplications();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Пользователь не найден'),
      ));
    }
  }

  void _deleteApplication(int applicationId) async {
    final dbHelper = Provider
        .of<DatabaseNotifier>(context, listen: false)
        .databaseHelper;
    DriverApplicationHandler applicationHandler = DriverApplicationHandler(dbHelper.db);

    await applicationHandler.delete(applicationId);
    setState(() {
      _driverApplicationsFuture = _getAllApplications();
    });
  }

}

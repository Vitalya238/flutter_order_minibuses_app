import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kp/models/Route.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:provider/provider.dart';
import 'package:kp/services/route_handler.dart';

class ManageRoutes extends StatefulWidget {
  @override
  _ManageRoutesState createState() => _ManageRoutesState();
}

class _ManageRoutesState extends State<ManageRoutes> {
  late Future<List<MinibusesRoute>> _routesFuture;
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  late MinibusesRoute _selectedRoute;

  @override
  void initState() {
    super.initState();
    _routesFuture = _getAllRoutes();
  }

  Future<List<MinibusesRoute>> _getAllRoutes() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    RouteHandler routeHandler = RouteHandler(dbHelper.db);

    return routeHandler.getAllRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Routes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddRouteForm(),
            SizedBox(height: 20),
            _buildRoutesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddRouteForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Route',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _departureController,
          decoration: InputDecoration(
            labelText: 'Point of Departure ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _destinationController,
          decoration: InputDecoration(
            labelText: 'Point of Destination ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _timeController,
          decoration: InputDecoration(
            labelText: 'Route Time',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addRoute,
          child: Text('Add Route'),
        ),
      ],
    );
  }

  void _addRoute() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    RouteHandler routeHandler = RouteHandler(dbHelper.db);

    int departureID = int.tryParse(_departureController.text) ?? 0;
    int destinationID = int.tryParse(_destinationController.text) ?? 0;
    String time = _timeController.text;

    if (departureID > 0 && destinationID > 0 && time.isNotEmpty) {
      MinibusesRoute newRoute = MinibusesRoute(departureID, destinationID, time);
      await routeHandler.insert(newRoute);
      setState(() {
        _routesFuture = _getAllRoutes();
        _departureController.clear();
        _destinationController.clear();
        _timeController.clear();
      });
    }
  }

  Widget _buildRoutesList() {
    return Expanded(
      child: FutureBuilder(
        future: _routesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<MinibusesRoute> routes = snapshot.data as List<MinibusesRoute>;
            return ListView.builder(
              itemCount: routes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Route ${routes[index].id}'),
                  subtitle: Text(
                      'Departure ID: ${routes[index].pointOfDepartureID}, Destination ID: ${routes[index].pointOfDestinationID}, Time: ${routes[index].routeTime}'),
                  onTap: () {
                    _editRoute(context, routes[index]);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteRoute(context, routes[index]);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _editRoute(BuildContext context, MinibusesRoute route) {
    setState(() {
      _selectedRoute = route;
      _departureController.text = route.pointOfDepartureID.toString();
      _destinationController.text = route.pointOfDestinationID.toString();
      _timeController.text = route.routeTime;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Route'),
          content: _buildEditRouteForm(),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _saveEditedRoute();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditRouteForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _departureController,
          decoration: InputDecoration(
            labelText: 'Point of Departure ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _destinationController,
          decoration: InputDecoration(
            labelText: 'Point of Destination ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _timeController,
          decoration: InputDecoration(
            labelText: 'Route Time',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  void _saveEditedRoute() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    RouteHandler routeHandler = RouteHandler(dbHelper.db);

    int departureID = int.tryParse(_departureController.text) ?? 0;
    int destinationID = int.tryParse(_destinationController.text) ?? 0;
    String time = _timeController.text;

    if (departureID > 0 && destinationID > 0 && time.isNotEmpty) {
      MinibusesRoute updatedRoute = MinibusesRoute(departureID, destinationID, time);
      updatedRoute.id = _selectedRoute.id;
      await routeHandler.update(updatedRoute);
      setState(() {
        _routesFuture = _getAllRoutes();
        _departureController.clear();
        _destinationController.clear();
        _timeController.clear();
      });
    }
  }

  void _deleteRoute(BuildContext context, MinibusesRoute route) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    RouteHandler routeHandler = RouteHandler(dbHelper.db);

    await routeHandler.delete(route.id);
    setState(() {
      _routesFuture = _getAllRoutes();
    });
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kp/models/Bus.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:kp/services/bus_handler.dart';
import 'package:provider/provider.dart';

class ManageMinibuses extends StatefulWidget {
  @override
  _ManageMinibusesState createState() => _ManageMinibusesState();
}

class _ManageMinibusesState extends State<ManageMinibuses> {
  late Future<List<Bus>> _busesFuture;
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _placesController = TextEditingController();

  late Bus _selectedBus;

  @override
  void initState() {
    super.initState();
    _busesFuture = _getAllBuses();
  }

  Future<List<Bus>> _getAllBuses() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    BusHandler busHandler = BusHandler(dbHelper.db);

    return busHandler.getAllBuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Minibuses',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddBusForm(),
            SizedBox(height: 20),
            _buildBusesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBusForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Minibus',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _brandController,
          decoration: InputDecoration(
            labelText: 'Brand',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _numberController,
          decoration: InputDecoration(
            labelText: 'Number',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _placesController,
          decoration: InputDecoration(
            labelText: 'Number of Places',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addBus,
          child: Text('Add Bus'),
        ),
      ],
    );
  }

  void _addBus() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    BusHandler busHandler = BusHandler(dbHelper.db);

    String brand = _brandController.text;
    String number = _numberController.text;
    int places = int.tryParse(_placesController.text) ?? 0;

    if (brand.isNotEmpty && number.isNotEmpty && places > 0) {
      Bus newBus = Bus(brand, number, places, Uint8List(0));
      await busHandler.insert(newBus);
      setState(() {
        _busesFuture = _getAllBuses();
        _brandController.clear();
        _numberController.clear();
        _placesController.clear();
      });
    }
  }

  Widget _buildBusesList() {
    return Expanded(
      child: FutureBuilder(
        future: _busesFuture,
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
            List<Bus> buses = snapshot.data as List<Bus>;
            return ListView.builder(
              itemCount: buses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('id: ${buses[index].id}, Brand: ${buses[index].busBrand} - Number: ${buses[index].busNumber}'),
                  subtitle: Text('Number of places: ${buses[index].countPlaces}'),
                  onTap: () {
                    _editBus(context, buses[index]);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteBus(context, buses[index]);
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

  void _editBus(BuildContext context, Bus bus) {
    setState(() {
      _selectedBus = bus;
      _brandController.text = bus.busBrand;
      _numberController.text = bus.busNumber;
      _placesController.text = bus.countPlaces.toString();
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Bus'),
          content: _buildEditBusForm(),
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
                _saveEditedBus();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditBusForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _brandController,
          decoration: InputDecoration(
            labelText: 'Brand',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _numberController,
          decoration: InputDecoration(
            labelText: 'Number',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _placesController,
          decoration: InputDecoration(
            labelText: 'Number of Places',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  void _saveEditedBus() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    BusHandler busHandler = BusHandler(dbHelper.db);

    String brand = _brandController.text;
    String number = _numberController.text;
    int places = int.tryParse(_placesController.text) ?? 0;

    if (brand.isNotEmpty && number.isNotEmpty && places > 0) {
      Bus updatedBus = Bus(brand, number, places, Uint8List(0));
      updatedBus.id = _selectedBus.id;
      await busHandler.update(updatedBus);
      setState(() {
        _busesFuture = _getAllBuses();
        _brandController.clear();
        _numberController.clear();
        _placesController.clear();
      });
    }
  }

  void _deleteBus(BuildContext context, Bus bus) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    BusHandler busHandler = BusHandler(dbHelper.db);

    await busHandler.delete(bus.id);
    setState(() {
      _busesFuture = _getAllBuses();
    });
  }
}

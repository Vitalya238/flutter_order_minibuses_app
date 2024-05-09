import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kp/models/City.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:kp/services/city_handler.dart';
import 'package:provider/provider.dart';

class ManageCities extends StatefulWidget {
  @override
  _ManageCitiesState createState() => _ManageCitiesState();
}

class _ManageCitiesState extends State<ManageCities> {
  late Future<List<City>> _citiesFuture;
  final TextEditingController _cityNameController = TextEditingController();

  late City _selectedCity;

  @override
  void initState() {
    super.initState();
    _citiesFuture = _getAllCities();
  }

  Future<List<City>> _getAllCities() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    CityHandler cityHandler = CityHandler(dbHelper.db);

    return cityHandler.getAllCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Cities',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddCityForm(),
            SizedBox(height: 20),
            _buildCitiesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCityForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add City',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _cityNameController,
          decoration: InputDecoration(
            labelText: 'City Name',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addCity,
          child: Text('Add City'),
        ),
      ],
    );
  }

  void _addCity() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    CityHandler cityHandler = CityHandler(dbHelper.db);

    String cityName = _cityNameController.text;

    if (cityName.isNotEmpty) {
      City newCity = City(cityName);
      await cityHandler.insert(newCity);
      setState(() {
        _citiesFuture = _getAllCities();
        _cityNameController.clear();
      });
    }
  }

  Widget _buildCitiesList() {
    return Expanded(
      child: FutureBuilder(
        future: _citiesFuture,
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
            List<City> cities = snapshot.data as List<City>;
            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('id: ${cities[index].cityId}, name: ${cities[index].cityName}'),
                  onTap: () {
                    _editCity(context, cities[index]);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteCity(context, cities[index]);
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

  void _editCity(BuildContext context, City city) {
    setState(() {
      _selectedCity = city;
      _cityNameController.text = city.cityName;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit City'),
          content: _buildEditCityForm(),
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
                _saveEditedCity();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditCityForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _cityNameController,
          decoration: InputDecoration(
            labelText: 'City Name',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  void _saveEditedCity() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    CityHandler cityHandler = CityHandler(dbHelper.db);

    String cityName = _cityNameController.text;

    if (cityName.isNotEmpty) {
      City updatedCity = City(cityName);
      updatedCity.cityId = _selectedCity.cityId;
      await cityHandler.update(updatedCity);
      setState(() {
        _citiesFuture = _getAllCities();
        _cityNameController.clear();
      });
    }
  }

  void _deleteCity(BuildContext context, City city) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    CityHandler cityHandler = CityHandler(dbHelper.db);

    await cityHandler.delete(city.cityId);
    setState(() {
      _citiesFuture = _getAllCities();
    });
  }
}

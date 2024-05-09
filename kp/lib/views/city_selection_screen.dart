import 'package:flutter/material.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:kp/models/City.dart';
import 'package:kp/services/city_handler.dart';
import 'package:provider/provider.dart';

class CitySelectionScreen extends StatefulWidget {
  final String title;

  const CitySelectionScreen({Key? key, required this.title}) : super(key: key);

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  late Future<List<City>> _citiesFuture;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
        title: Text(widget.title),
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Поиск города',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<City>>(
              future: _citiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else {
                  List<City> cities = snapshot.data!;
                  cities = cities!
                      .where((city) =>
                      city.cityName.toLowerCase().contains(_searchController.text.toLowerCase()))
                      .toList();
                  return ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(cities[index].cityName),
                        onTap: () {
                          Navigator.pop(context, cities[index].cityName);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

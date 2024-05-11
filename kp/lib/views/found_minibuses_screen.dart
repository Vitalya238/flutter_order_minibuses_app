import 'package:flutter/material.dart';
import 'package:kp/services/trip_handler.dart';
import 'package:provider/provider.dart';

import '../services/database_notifier.dart';

class FoundMinibusesScreen extends StatefulWidget {
  final String from;
  final String to;
  final String date;
  final String passengers;

  const FoundMinibusesScreen({
    Key? key,
    required this.from,
    required this.to,
    required this.date,
    required this.passengers,
  }) : super(key: key);

  @override
  _FoundMinibusesScreenState createState() => _FoundMinibusesScreenState();
}

class _FoundMinibusesScreenState extends State<FoundMinibusesScreen> {
  late Future<List<Map<String, dynamic>>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _tripsFuture = _getAllTrips();
  }

  Future<List<Map<String, dynamic>>> _getAllTrips() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    TripHandler tripHandler = TripHandler(dbHelper.db);
    print(await tripHandler.getAllTripsWithCities());
    return tripHandler.getAllTripsWithCities();
  }

  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Найденные рейсы'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tripsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return ListTile(
                  title: Text('Рейс №${data['TRIPID']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Откуда: ${data['DepartureCityName']}'),
                      Text('Куда: ${data['DestinationCityName']}'),
                      Text('Время отправления: ${data['DEPARTURE_TIME']}'),
                      Text('Время прибытия: ${data['DESTINATION_TIME']}'),
                      Text('Свободные места: ${data['COUNT_FREE_PLACES']}'),
                      Text('Стоимость: ${data['COST']}'),
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


}

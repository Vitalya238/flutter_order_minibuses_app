import 'package:flutter/material.dart';
import 'package:kp/models/Trip.dart';
import 'package:kp/services/database_helper.dart';
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
  late Future<List<Trip>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _tripsFuture = _getAllTrips();
  }

  Future<List<Trip>> _getAllTrips() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    TripHandler tripHandler = TripHandler(dbHelper.db);
    return tripHandler.getAllTrips();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Найденные рейсы'),
      ),
      body: FutureBuilder<List<Trip>>(
        future: _tripsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            List<Trip> trips = snapshot.data!;
            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> map = snapshot.data![index].toMap();
                return ListTile(
                  title: Text('Рейс №${trips[index].tripId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Откуда: ${map['DepartureCityName']}'),
                      Text('Куда: ${map['DestinationCityName']}'),
                      Text('Количество пассажиров: ${widget.passengers}'),
                      Text('Время отправления: ${trips[index].departureTime}'),
                      Text('Время прибытия: ${trips[index].destinationTime}'),
                      Text('Свободные места: ${trips[index].countFreePlaces}'),
                      Text('Стоимость: ${trips[index].cost}'),
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

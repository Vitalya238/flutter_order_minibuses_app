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

    return tripHandler.getAllTripsWithCities(widget.date, int.parse(widget.passengers), widget.from, widget.to);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
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
                      Row(
                        children: [
                          Text('${data['DEPARTURE_TIME']}'),
                          Text('${data['DESTINATION_TIME']}'),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      ),
                      Row(
                        children: [
                          Text('${data['DEPARTURE_DATE']}'),
                          Text('${data['DESTINATION_DATE']}'),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      ),
                      Row(
                        children: [
                          Text('${data['DepartureCityName']}'),
                          Text('${data['DestinationCityName']}'),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      ),
                      Row(
                        children: [
                          Text('Свободные места: ${data['COUNT_FREE_PLACES']}'),
                          Text('Стоимость: ${data['COST']}'),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      ),
                      ElevatedButton(
                        onPressed: _orderTicket,
                        child: Center(
                           child : Text('Buy'),
                        ),
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

  void _orderTicket() {
    
  }
}

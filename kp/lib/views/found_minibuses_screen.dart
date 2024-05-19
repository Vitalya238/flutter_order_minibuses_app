import 'package:flutter/material.dart';
import 'package:kp/models/Order.dart';
import 'package:kp/models/Trip.dart';
import 'package:kp/services/order_handler.dart';
import 'package:kp/services/trip_handler.dart';
import 'package:provider/provider.dart';
import '../models/Client.dart';
import '../services/database_notifier.dart';
import 'widgets/widget.dart';
import 'package:kp/services/auth_notifier.dart';

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
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, authNotifier, child) {
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        color: Color.fromRGBO(255, 227, 135, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.grey, width: 1),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Рейс №${data['TRIPID']}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text(
                                    '${data['DEPARTURE_TIME']}',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    '${data['DESTINATION_TIME']}',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text('${data['DEPARTURE_DATE']}'),
                                  Text('${data['DESTINATION_DATE']}'),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text(
                                    '${data['DepartureCityName']}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${data['DestinationCityName']}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text(
                                    'Свободные места: ${data['COUNT_FREE_PLACES']}',
                                    style: TextStyle(color: Color.fromRGBO(100, 150, 100, 1), fontWeight: FontWeight.w500),
                                  ),
                                  Text('Стоимость: ${data['COST']} USD'),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  if (authNotifier.currentUser.roleId == 2) {
                                    _confirmOrder(context, data['TRIPID'], authNotifier.currentUser);
                                  }
                                },
                                child: Center(
                                  child: Text('Buy'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
  void _confirmOrder(BuildContext context, int tripId, Client currentUser) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Order'),
        content: Text('Do you want to buy this ticket?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _orderTicket(tripId, currentUser);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _orderTicket(int selectedTripId, Client currentUser) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    OrderHandler orderHandler = OrderHandler(dbHelper.db);
    Order order = Order(
      selectedTripId,
      currentUser.userId,
      int.parse(widget.passengers),
    );
    await orderHandler.insert(order);

    await _updateTrip(selectedTripId); // Обновляем информацию о рейсе

    setState(() {
      // После того, как обновили информацию о рейсе, обновляем список рейсов
      _tripsFuture = _getAllTrips();
    });
  }

  Future<void> _updateTrip(int tripId) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    TripHandler tripHandler = TripHandler(dbHelper.db);
    Trip? trip = await tripHandler.getTrip(tripId);
    if (trip != null) {
      if (trip.countFreePlaces < int.parse(widget.passengers)) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Not enough available places'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        int selectedPassengers = int.parse(widget.passengers);
        trip.countFreePlaces -= selectedPassengers;
        await tripHandler.update(trip);
      }
    }
  }

}

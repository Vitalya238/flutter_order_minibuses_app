import 'package:flutter/material.dart';
import 'package:kp/models/Trip.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:kp/services/order_handler.dart';
import 'package:kp/services/trip_handler.dart';
import 'package:provider/provider.dart';
import 'package:kp/services/auth_notifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:collection';

class DriverTripsScreen extends StatefulWidget {
  @override
  _DriverTripsScreenState createState() => _DriverTripsScreenState();
}

class _DriverTripsScreenState extends State<DriverTripsScreen> {
  late Future<Map<int, List<Map<String, dynamic>>>> _ordersFuture;
  late int currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<AuthNotifier>(context, listen: false).currentUser.userId;
    _ordersFuture = _getAllOrdersGroupedByTrip(currentUserId);
  }

  Future<Map<int, List<Map<String, dynamic>>>> _getAllOrdersGroupedByTrip(int currentUserID) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    OrderHandler orderHandler = OrderHandler(dbHelper.db);
    List<Map<String, dynamic>> allOrders = await orderHandler.getAllTripsForDrivers(currentUserID);

    // Группируем заказы по ID рейса
    Map<int, List<Map<String, dynamic>>> groupedOrders = {};
    for (var order in allOrders) {
      int tripId = order['TRIPID'];
      if (!groupedOrders.containsKey(tripId)) {
        groupedOrders[tripId] = [];
      }
      groupedOrders[tripId]!.add(order);
    }

    return groupedOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, authNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            title: const Text('История заказов',
              style: TextStyle(fontWeight: FontWeight.w600),),
          ),
          body: FutureBuilder<Map<int, List<Map<String, dynamic>>>>(
            future: _ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Ошибка: ${snapshot.error}'));
              } else {
                Map<int, List<Map<String, dynamic>>> groupedOrders = snapshot.data!;
                return ListView.builder(
                  itemCount: groupedOrders.keys.length,
                  itemBuilder: (context, index) {
                    int tripId = groupedOrders.keys.elementAt(index);
                    List<Map<String, dynamic>> orders = groupedOrders[tripId]!;

                    return Card(
                      color: Color.fromRGBO(255, 227, 135, 1),
                      child: ListTile(
                        title: Text('Рейс №$tripId'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: orders.map((order) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Имя пассажира: ${order['PassengerLastName']}'),
                                ElevatedButton(
                                  onPressed: () => _launchUrl('${order['PassengerPhoneNum']}'),
                                  child: Text('Позвонить: ${order['PassengerPhoneNum']}'),
                                ),
                              ],
                            );
                          }).toList(),
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

  Future<void> _launchUrl(String phoneNum) async {
    Uri _url = Uri.parse('tel:$phoneNum');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _cancelTrip(BuildContext context, int tripId, int orderId, passQuant) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    OrderHandler orderHandler = OrderHandler(dbHelper.db);

    _updateTrip(tripId, passQuant);
    await orderHandler.delete(orderId);
    setState(() {
      _ordersFuture = _getAllOrdersGroupedByTrip(currentUserId);
    });
  }

  void _updateTrip(int tripId, int passQuant) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    TripHandler tripHandler = TripHandler(dbHelper.db);
    Trip? trip = await tripHandler.getTrip(tripId);
    if (trip != null) {
      int selectedPassengers = passQuant;
      trip.countFreePlaces += selectedPassengers;
      await tripHandler.update(trip);
    }
  }
}

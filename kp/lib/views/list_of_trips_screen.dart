import 'package:flutter/material.dart';
import 'package:kp/models/Order.dart';
import 'package:kp/models/Trip.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:kp/services/order_handler.dart';
import 'package:kp/services/trip_handler.dart';
import 'package:provider/provider.dart';
import 'package:kp/services/auth_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class ListOfTripsScreen extends StatefulWidget {
  @override
  _ListOfTripsScreenState createState() => _ListOfTripsScreenState();
}

class _ListOfTripsScreenState extends State<ListOfTripsScreen> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  late int currentUserId;
  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<AuthNotifier>(context, listen: false).currentUser.userId;
    _ordersFuture = _getAllOrders(currentUserId);
  }

  Future<List<Map<String, dynamic>>> _getAllOrders(int currentUserID) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    OrderHandler orderHandler = OrderHandler(dbHelper.db);
    return orderHandler.getAllOrdersInfo(currentUserID);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, authNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            title: const Text('История заказов'),
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _ordersFuture,
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
                      title: Row(
                        children: [
                          Text('Рейс №${data['TRIPID']}'),
                          Text('${data['TripCost']} USD'),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('${data['TripDepartureDate']}'),
                              Text('${data['TripDestinationDate']}'),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Row(
                            children: [
                              Text('${data['TripDepartureTime']}'),
                              Text('${data['TripDestinationTime']}'),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Row(
                            children: [
                              Text('${data['DepartureCityName']}'),
                              Text('${data['DestinationCityName']}'),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Row(
                            children: [
                              Text('Имя Водителя: ${data['DRIVER_USERLASTNAME']}'),
                              ElevatedButton(
                                onPressed: () => _launchUrl('${data['DRIVER_TELEPHONE']}'),
                                child: Text('Call ${data['DRIVER_TELEPHONE']}'),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Row(
                            children: [
                              Text('Brand: ${data['BusBrand']}'),
                              Text('BUSNumber: ${data['BusNumber']}'),
                              Text('PassengersQuantity: ${data['PassengersQuantity']}'),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          ElevatedButton(
                            onPressed: () => _cancelTrip(context, data['TRIPID'],data['ORDERID'], data['PassengersQuantity']),
                            child: Text('Отказаться'),
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
      },
    );
  }
  Future<void> _launchUrl(String phoneNum) async {
    Uri _url = Uri.parse('tel:${phoneNum}');
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
      _ordersFuture = _getAllOrders(currentUserId);
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

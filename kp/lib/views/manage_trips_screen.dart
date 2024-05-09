import 'package:flutter/material.dart';
import 'package:kp/models/Trip.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:kp/services/trip_handler.dart';
import 'package:provider/provider.dart';

class ManageTrips extends StatefulWidget {
  @override
  _ManageTripsState createState() => _ManageTripsState();
}

class _ManageTripsState extends State<ManageTrips> {
  late Future<List<Trip>> _tripsFuture;
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _destinationDateController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();
  final TextEditingController _destinationTimeController = TextEditingController();
  final TextEditingController _countFreePlacesController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _routeIdController = TextEditingController();
  final TextEditingController _busIdController = TextEditingController();
  final TextEditingController _driverIdController = TextEditingController();

  late Trip _selectedTrip;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Trips',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddTripForm(),
              SizedBox(height: 20),
              _buildTripsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddTripForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Trip',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _departureDateController,
          decoration: InputDecoration(
            labelText: 'Departure Date',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _destinationDateController,
          decoration: InputDecoration(
            labelText: 'Destination Date',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _departureTimeController,
          decoration: InputDecoration(
            labelText: 'Departure Time',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _destinationTimeController,
          decoration: InputDecoration(
            labelText: 'Destination Time',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _countFreePlacesController,
          decoration: InputDecoration(
            labelText: 'Number of Free Places',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _costController,
          decoration: InputDecoration(
            labelText: 'Cost',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _routeIdController,
          decoration: InputDecoration(
            labelText: 'Route ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _busIdController,
          decoration: InputDecoration(
            labelText: 'Bus ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _driverIdController,
          decoration: InputDecoration(
            labelText: 'Driver ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addTrip,
          child: Text('Add Trip'),
        ),
      ],
    );
  }

  void _addTrip() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    TripHandler tripHandler = TripHandler(dbHelper.db);

    String departureDate = _departureDateController.text;
    String destinationDate = _destinationDateController.text;
    String departureTime = _departureTimeController.text;
    String destinationTime = _destinationTimeController.text;
    int countFreePlaces = int.tryParse(_countFreePlacesController.text) ?? 0;
    double cost = double.tryParse(_costController.text) ?? 0.0;
    int routeId = int.tryParse(_routeIdController.text) ?? 0;
    int busId = int.tryParse(_busIdController.text) ?? 0;
    int driverId = int.tryParse(_driverIdController.text) ?? 0;

    if (departureDate.isNotEmpty &&
        destinationDate.isNotEmpty &&
        departureTime.isNotEmpty &&
        destinationTime.isNotEmpty &&
        countFreePlaces > 0 &&
        cost > 0 &&
        routeId > 0 &&
        busId > 0 &&
        driverId > 0) {
      Trip newTrip = Trip(
        departureDate,
        destinationDate,
        departureTime,
        destinationTime,
        countFreePlaces,
        cost,
        routeId,
        busId,
        driverId,
      );
      await tripHandler.insert(newTrip);
      setState(() {
        _tripsFuture = _getAllTrips();
        _departureDateController.clear();
        _destinationDateController.clear();
        _departureTimeController.clear();
        _destinationTimeController.clear();
        _countFreePlacesController.clear();
        _costController.clear();
        _routeIdController.clear();
        _busIdController.clear();
        _driverIdController.clear();
      });
    }
  }


  Widget _buildTripsList() {
    return FutureBuilder(
      future: _tripsFuture,
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
          List<Trip> trips = snapshot.data as List<Trip>;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  'Trip ID: ${trips[index].tripId}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Departure Date: ${trips[index].departureDate}'),
                    Text('Destination Date: ${trips[index].destinationDate}'),
                    Text('Departure Time: ${trips[index].departureTime}'),
                    Text('Destination Time: ${trips[index].destinationTime}'),
                    Text('Number of Free Places: ${trips[index].countFreePlaces}'),
                    Text('Cost: ${trips[index].cost}'),
                    Text('Route ID: ${trips[index].routeId}'),
                    Text('Bus ID: ${trips[index].busId}'),
                    Text('Driver ID: ${trips[index].driverId}'),
                  ],
                ),
                onTap: () {
                  _editTrip(context, trips[index]);
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteTrip(context, trips[index]);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  void _editTrip(BuildContext context, Trip trip) {
    setState(() {
      _selectedTrip = trip;
      _departureDateController.text = trip.departureDate;
      _destinationDateController.text = trip.destinationDate;
      _departureTimeController.text = trip.departureTime;
      _destinationTimeController.text = trip.destinationTime;
      _countFreePlacesController.text = trip.countFreePlaces.toString();
      _costController.text = trip.cost.toString();
      _routeIdController.text = trip.routeId.toString();
      _busIdController.text = trip.busId.toString();
      _driverIdController.text = trip.driverId.toString();
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Trip'),
          content: _buildEditTripForm(),
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
                _saveEditedTrip();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditTripForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _departureDateController,
          decoration: InputDecoration(
            labelText: 'Departure Date',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _destinationDateController,
          decoration: InputDecoration(
            labelText: 'Destination Date',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _departureTimeController,
          decoration: InputDecoration(
            labelText: 'Departure Time',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _destinationTimeController,
          decoration: InputDecoration(
            labelText: 'Destination Time',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _countFreePlacesController,
          decoration: InputDecoration(
            labelText: 'Number of Free Places',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _costController,
          decoration: InputDecoration(
            labelText: 'Cost',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _routeIdController,
          decoration: InputDecoration(
            labelText: 'Route ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _busIdController,
          decoration: InputDecoration(
            labelText: 'Bus ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _driverIdController,
          decoration: InputDecoration(
            labelText: 'Driver ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  void _saveEditedTrip() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    TripHandler tripHandler = TripHandler(dbHelper.db);

    String departureDate = _departureDateController.text;
    String destinationDate = _destinationDateController.text;
    String departureTime = _departureTimeController.text;
    String destinationTime = _destinationTimeController.text;
    int countFreePlaces = int.tryParse(_countFreePlacesController.text) ?? 0;
    double cost = double.tryParse(_costController.text) ?? 0.0;
    int routeId = int.tryParse(_routeIdController.text) ?? 0;
    int busId = int.tryParse(_busIdController.text) ?? 0;
    int driverId = int.tryParse(_driverIdController.text) ?? 0;

    if (departureDate.isNotEmpty &&
        destinationDate.isNotEmpty &&
        departureTime.isNotEmpty &&
        destinationTime.isNotEmpty &&
        countFreePlaces > 0 &&
        cost > 0 &&
        routeId > 0 &&
        busId > 0 &&
        driverId > 0) {
      Trip updatedTrip = Trip(
        departureDate,
        destinationDate,
        departureTime,
        destinationTime,
        countFreePlaces,
        cost,
        routeId,
        busId,
        driverId,
      );
      await tripHandler.update(updatedTrip);
      setState(() {
        _tripsFuture = _getAllTrips();
        _departureDateController.clear();
        _destinationDateController.clear();
        _departureTimeController.clear();
        _destinationTimeController.clear();
        _countFreePlacesController.clear();
        _costController.clear();
        _routeIdController.clear();
        _busIdController.clear();
        _driverIdController.clear();
      });
    }
  }

  void _deleteTrip(BuildContext context, Trip trip) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    TripHandler tripHandler = TripHandler(dbHelper.db);

    await tripHandler.delete(trip.tripId);
    setState(() {
      _tripsFuture = _getAllTrips();
    });
  }
}

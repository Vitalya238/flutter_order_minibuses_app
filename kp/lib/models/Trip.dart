class Trip {
  final String tableName = 'TRIP';
  final String columnTripId = 'TRIPID';
  final String columnDepartureDate = 'DEPARTURE_DATE';
  final String columnDestinationDate = 'DESTINATION_DATE';
  final String columnDepartureTime = 'DEPARTURE_TIME';
  final String columnDestinationTime = 'DESTINATION_TIME';
  final String columnCountFreePlaces = 'COUNT_FREE_PLACES';
  final String columnCost = 'COST';
  final String columnRouteId = 'ROUTEID';
  final String columnBusId = 'BUSID';
  final String columnDriverId = 'DRIVERID';

  int tripId = 0;
  late String departureDate;
  late String destinationDate;
  late String departureTime;
  late String destinationTime;
  late int countFreePlaces;
  late double cost;
  late int routeId;
  late int busId;
  late int driverId;

  Trip(
      this.departureDate,
      this.destinationDate,
      this.departureTime,
      this.destinationTime,
      this.countFreePlaces,
      this.cost,
      this.routeId,
      this.busId,
      this.driverId,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnDepartureDate: departureDate,
      columnDestinationDate: destinationDate,
      columnDepartureTime: departureTime,
      columnDestinationTime: destinationTime,
      columnCountFreePlaces: countFreePlaces,
      columnCost: cost,
      columnRouteId: routeId,
      columnBusId: busId,
      columnDriverId: driverId,
    };
    if (tripId != 0) {
      map[columnTripId] = tripId;
    }
    return map;
  }

  Trip.fromMap(Map<dynamic, dynamic> map) {
    tripId = map[columnTripId] ?? 0;
    departureDate = map[columnDepartureDate];
    destinationDate = map[columnDestinationDate];
    departureTime = map[columnDepartureTime];
    destinationTime = map[columnDestinationTime];
    countFreePlaces = map[columnCountFreePlaces];
    cost = map[columnCost];
    routeId = map[columnRouteId];
    busId = map[columnBusId];
    driverId = map[columnDriverId];
  }
}

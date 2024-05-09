import 'package:sqflite/sqflite.dart';
import 'package:kp/models/Trip.dart';

const String tableName = 'TRIP';
const String columnTripId = 'TRIPID';
const String columnDepartureDate = 'DEPARTURE_DATE';
const String columnDestinationDate = 'DESTINATION_DATE';
const String columnDepartureTime = 'DEPARTURE_TIME';
const String columnDestinationTime = 'DESTINATION_TIME';
const String columnCountFreePlaces = 'COUNT_FREE_PLACES';
const String columnCost = 'COST';
const String columnRouteId = 'ROUTEID';
const String columnBusId = 'BUSID';
const String columnDriverId = 'DRIVERID';

class TripHandler {
  late Database db;
  TripHandler(this.db);
  Future createTable() async {
    await db.execute('''
        create table IF NOT EXISTS $tableName ($columnTripId INTEGER PRIMARY KEY autoincrement,
                                $columnDepartureDate TEXT not null,
                                $columnDestinationDate TEXT not null,
                                $columnDepartureTime TEXT not null,
                                $columnDestinationTime TEXT NOT NULL,
                                $columnCountFreePlaces INTEGER NOT NULL,
                                $columnCost REAL NUT NULL,
                                $columnRouteId INTEGER NOT NULL,
                                $columnBusId INTEGER NOT NULL,
                                $columnDriverId INTEGER NOT NULL,
                                FOREIGN KEY ($columnBusId) REFERENCES BUS(BUSID),
                                FOREIGN KEY ($columnRouteId) REFERENCES ROUTE(ROUTEID),
                                FOREIGN KEY ($columnDriverId) REFERENCES CLIENT(USERID))
      ''');

  }
  Future<int> insert(Trip trip) async{
    return await db.insert(tableName, trip.toMap());
  }
  Future<Trip?> getTrip(int id) async{
    List<Map> maps = await db.query(tableName,
        columns: [columnTripId, columnDepartureDate, columnDestinationDate, columnDepartureTime, columnDestinationTime, columnCountFreePlaces,columnCost,columnRouteId,columnBusId,columnDriverId],
        where: '$columnTripId = ?',
        whereArgs: [id]);
    if(maps.isNotEmpty){
      return Trip.fromMap(maps.first);
    }
    return null;
  }
  Future<int> delete(int id) async{
    return await db.delete(tableName, where: '$columnTripId = ?', whereArgs: [id]);
  }
  Future<int> update(Trip trip) async{
    return await db.update(tableName, trip.toMap(), where: '$columnTripId = ?', whereArgs: [trip.tripId]);
  }


  Future<List<Trip>> getAllTrips() async{
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<Trip> routes = [];
    for(var map in maps){
      routes.add(Trip.fromMap(map));
    }
    return routes;
  }

  Future close() async => db.close();
}

import 'package:kp/models/Order.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kp/models/Trip.dart';
import 'package:kp/models/Client.dart';

const String tableName = 'ORDERS';
const String columnOrderID = 'ORDERID';
const String columnTripID = 'TRIPID';
const String columnClientID = 'CLIENTID';
const String columnPassengersQuantity = 'PASSENGERSQUANTITY';

class OrderHandler {
  late Database db;
  OrderHandler(this.db);
  Future createTable() async {
    await db.execute('''
        create table IF NOT EXISTS `$tableName` (`$columnOrderID` INTEGER PRIMARY KEY autoincrement,
                                `$columnTripID` INTEGER not null,
                                `$columnClientID` INTEGER not null,
                                `$columnPassengersQuantity` INTEGER not null,
                                FOREIGN KEY (`$columnTripID`) REFERENCES BUS(TRIPID),
                                FOREIGN KEY (`$columnClientID`) REFERENCES ROUTE(USERID))
      ''');
  }

  Future<int> insert(Order order) async{
    return await db.insert(tableName, order.toMap());
  }

  Future<Order?> getTrip(int id) async{
    List<Map> maps = await db.query(tableName,
        columns: [columnOrderID, columnTripID, columnClientID],
        where: '$columnOrderID = ?',
        whereArgs: [id]);
    if(maps.isNotEmpty){
      return Order.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async{
    return await db.delete(tableName, where: '$columnOrderID = ?', whereArgs: [id]);
  }

  Future<int> update(Order order) async{
    return await db.update(tableName, order.toMap(), where: '$columnOrderID = ?', whereArgs: [order.orderID]);
  }

  Future<List<Order>> getAllOrders() async{
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<Order> orders = [];
    for(var map in maps){
      orders.add(Order.fromMap(map));
    }
    return orders;
  }

  Future<List<Map<String, dynamic>>> getAllOrdersInfo(
      int userId
      ) async {
    String sqlQuery = '''
    SELECT $tableName.$columnOrderID, $tableName.$columnTripID, $tableName.$columnClientID, $tableName.$columnPassengersQuantity as PassengersQuantity, 
      TRIP.TRIPID, TRIP.DEPARTURE_DATE as TripDepartureDate, TRIP.DESTINATION_DATE as TripDestinationDate, TRIP.DEPARTURE_TIME as TripDepartureTime, TRIP.DESTINATION_TIME as TripDestinationTime, TRIP.COST as TripCost, 
      CITY_DEPARTURE.CITYNAME as DepartureCityName,
      CITY_DESTINATION.CITYNAME as DestinationCityName,
      DRIVER.TELEPHONE as DRIVER_TELEPHONE, DRIVER.USERLASTNAME as DRIVER_USERLASTNAME,
      MINIBUS.BUSBRAND as BusBrand, MINIBUS.BUSNUMBER as BusNumber
    FROM $tableName
    INNER JOIN TRIP ON $tableName.$columnTripID = TRIP.TRIPID
    INNER JOIN ROUTE ON ROUTE.ROUTEID = TRIP.ROUTEID
    INNER JOIN CITY as CITY_DEPARTURE ON ROUTE.POINT_OF_DEPARTUREID = CITY_DEPARTURE.CITYID
    INNER JOIN CITY as CITY_DESTINATION ON ROUTE.POINT_OF_DESTINATIONID = CITY_DESTINATION.CITYID
    INNER JOIN CLIENT as DRIVER ON DRIVER.USERID = TRIP.DRIVERID
    INNER JOIN BUS as MINIBUS ON MINIBUS.BUSID = TRIP.BUSID
    WHERE $tableName.$columnClientID = ?
  ''';

    List<Map<String, dynamic>> results = await db.rawQuery(sqlQuery, [userId]);
    return results;
  }

  Future close() async => db.close();
}

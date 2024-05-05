import 'package:sqflite/sqflite.dart';
import 'BusHandler.dart';
import 'BusStopHandler.dart';
import 'CityHandler.dart';
import 'ClientHandler.dart';
import 'RoleHandler.dart';
import 'RouteHandler.dart';
import 'TicketHandler.dart';
import 'TripHandler.dart';


class DatabaseHelper{
  late Database db;
  Future init(String path) async{
    db = await openDatabase(path, version: 1,
        onCreate: (db, version) async{
          await CityHandler(db).createTable();
          await RoleHandler(db).createTable();
          await ClientHandler(db).createTable();
          await BusHandler(db).createTable();
          await RouteHandler(db).createTable();
          await BusStopHandler(db).createTable();
          await TripHandler(db).createTable();
          await TicketHandler(db).createTable();
    });
  }


  Future close() async => db.close();
}
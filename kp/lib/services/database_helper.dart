import 'package:kp/services/bus_handler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kp/services/client_handler.dart';
import 'package:kp/services/role_handler.dart';

class DatabaseHelper {
  late Database db;

  DatabaseHelper() {
    init();
  }

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var fullPath = join(databasesPath, "database.db");
    db = await openDatabase(fullPath, version: 1,
        onCreate: (db, version) async {
          await ClientHandler(db).createTable();
          await RoleHandler(db).createTable();
          await BusHandler(db).createTable();
        });
  }

  Future<void> close() async => db.close();
}
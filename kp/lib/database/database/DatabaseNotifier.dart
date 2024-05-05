import 'package:flutter/cupertino.dart';
import 'package:kp/database/DatabaseHelper.dart';
class DatabaseNotifier extends ChangeNotifier {
  late DatabaseHelper _databaseHelper;

  DatabaseNotifier() {
    _databaseHelper = DatabaseHelper();
    _initDatabase();
  }

  void _initDatabase() async {
    await _databaseHelper.init("database.db");
    notifyListeners();
  }

  DatabaseHelper get databaseHelper => _databaseHelper;

}
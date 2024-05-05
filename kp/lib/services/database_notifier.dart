import 'package:flutter/cupertino.dart';
import 'package:kp/services/database_helper.dart';


class DatabaseNotifier extends ChangeNotifier {
  late DatabaseHelper _databaseHelper;

  DatabaseNotifier() {
    _databaseHelper = DatabaseHelper();
    _initDatabase();
  }

  void _initDatabase() async {
    await _databaseHelper.init();
    notifyListeners();
  }

  DatabaseHelper get databaseHelper => _databaseHelper;
}
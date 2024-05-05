import 'package:flutter/material.dart';
import 'package:kp/models/Client.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;
  late Client _currentUser = Client.empty();

  bool get isAuthenticated => _isAuthenticated;
  Client get currentUser => _currentUser;

  void login(Client user) {
    _isAuthenticated = true;
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = Client.empty();
    notifyListeners();
  }
}

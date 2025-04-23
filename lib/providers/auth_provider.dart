import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _error = "";
  final UserModel _userCredentials = UserModel(
    email: "admin",
    password: "admin123"
  );

  bool get isLoggedIn => _isLoggedIn;
  String get error => _error;

  void login(String email, String password) {
    if (email == _userCredentials.email && password == _userCredentials.password) {
      _isLoggedIn = true;
      _error = "";
    } else {
      _error = "Email or password is incorrect";
    }
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void clearError() {
    _error = "";
    notifyListeners();
  }
}
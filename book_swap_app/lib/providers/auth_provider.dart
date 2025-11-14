import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _userId;
  String? _email;
  bool _verified = false;

  String? get userId => _userId;
  String? get email => _email;
  bool get isVerified => _verified;
  bool get isLoggedIn => _userId != null;

  Future<bool> signup(String email, String password) async {
    // Mock signup
    _userId = email.hashCode.toString();
    _email = email;
    _verified = false;
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    // Mock login
    if (email.hashCode.toString() == _userId) {
      _email = email;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _userId = null;
    _email = null;
    _verified = false;
    notifyListeners();
  }

  Future<void> verifyEmail() async {
    _verified = true;
    notifyListeners();
  }
}

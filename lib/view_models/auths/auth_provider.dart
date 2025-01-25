import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? _token;
  bool _isAuthenticated = false;

  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  // check service
  Future<void> checkAuthState() async {
    final user = auth.currentUser;

    if (user != null) {
      _token = await user.getIdToken();
      _isAuthenticated = true;
    } else {
      _token = null;
      _isAuthenticated = false;
    }
    notifyListeners();
  }
}

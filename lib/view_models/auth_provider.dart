import 'package:chatting/view_models/profile_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  ProfileViewModel profileViewModel = ProfileViewModel();
  int _isAuthenticated = 0;

  int get isAuthenticated => _isAuthenticated;

  // check service
  Future<void> checkAuthState() async {
    final user = auth.currentUser;

    if (user != null) {
      bool checkDocumentUID = await profileViewModel.checkUIDExist();
      if (checkDocumentUID) {
        _isAuthenticated = 2;
      } else {
        _isAuthenticated = 1;
      }
    } else {
      _isAuthenticated = 0;
    }
    notifyListeners();
  }
}

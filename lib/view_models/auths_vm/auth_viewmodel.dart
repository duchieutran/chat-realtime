import 'package:chatting/services/auth_services.dart';
import 'package:flutter/cupertino.dart';

class AuthViewmodel extends ChangeNotifier {
  AuthServices authServices = AuthServices();

  // login
  bool login({required String email, required String password}) {
    try {
      authServices.login(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  // signup
  bool signUp({required String email, required String password}) {
    try {
      authServices.signup(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  // logout
  void logout() {
    authServices.logout();
  }
}

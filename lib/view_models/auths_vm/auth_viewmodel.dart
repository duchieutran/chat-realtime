import 'package:chatting/models/auth_error_model.dart';
import 'package:chatting/services/auth_services.dart';

class AuthViewmodel {
  AuthServices authServices = AuthServices();
  String message = '';
  bool status = false;

  // login
  Future<void> signIn(String email, String password) async {
    AuthErrorModel? errorModel =
        await authServices.login(email: email, password: password);

    if (errorModel == null) {
      message = "Login successful. Welcome back!";
      status = true;
    } else {
      message = errorModel.message;
    }
  }

  // signup
  Future<void> signUp(String email, String password) async {
    AuthErrorModel? errorModel =
        await authServices.singUp(email: email, password: password);
    if (errorModel == null) {
      message = "Your account has been created successfully. Welcome aboard!";
      status = true;
    } else {
      message = errorModel.message;
    }
  }

  // logout
  void logout() {
    authServices.logout();
  }
}

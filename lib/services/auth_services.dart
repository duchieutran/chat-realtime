import 'package:chatting/models/auth_error_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  // login
  Future<AuthErrorModel?> login(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return AuthErrorModel.fromFirebaseError(e);
    } catch (e) {
      return AuthErrorModel(
          code: "unknown ", message: "An unexpected error occurred.");
    }
  }

  // signup
  Future<AuthErrorModel?> singUp(
      {required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return AuthErrorModel.fromFirebaseError(e);
    } catch (e) {
      return AuthErrorModel(
          code: "unknown ", message: "An unexpected error occurred.");
    }
  }

  // logout
  logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Error during registration: $e');
    }
  }

//
}

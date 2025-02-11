import 'package:chatting/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  // login
  Future<bool> login({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // signup
  Future<SignUpStatus> signup({required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      return SignUpStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return SignUpStatus.emailAlreadyExists;
      } else {
        return SignUpStatus.error;
      }
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

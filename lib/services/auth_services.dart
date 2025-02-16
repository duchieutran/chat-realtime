import 'package:chatting/models/auth_error_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  // login
  Future<AuthErrorModel?> login(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await setIsOnline();
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
      await setOffline();
      await auth.signOut();
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  // cập nhật trạng thái người dùng
  Future<void> setIsOnline() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/${auth.currentUser!.uid}');
    await ref.set({'isOnline': true});
    await ref.onDisconnect().set({'isOnline': false});
  }

  Future<void> setOffline() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/${auth.currentUser!.uid}');
    await ref.set({'isOnline': false});
  }

  // Lắng nghe trạng thái online của người dùng
  Stream<bool> getUserStatus(String userId) {
    return FirebaseDatabase.instance
        .ref('users/$userId/isOnline')
        .onValue
        .map((event) => event.snapshot.value as bool? ?? false);
  }
}

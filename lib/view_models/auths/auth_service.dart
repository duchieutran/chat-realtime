import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // đăng nhập tài khoản
  Future<UserCredential?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email});
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  // Đăng kí tài khoản
  Future<UserCredential?> register(
      {required String email, required String password}) async {
    try {
      // create user
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // save user
      firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email});

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // lấy tài khoản người dùng hiện tại
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  // Đăng xuất tài khoản
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      print(firebaseAuth.currentUser);
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class ServiceAuths {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // phuong thuc dang ki
  Future<User?> registerUser({required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("==> Loi khi dang ki : $e");
      return null;
    }
  }

  // phuong thuc dang nhap
  Future<User?> signUp({required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("==> Loi khi dang nhap : $e");
      return null;
    }
  }

  // phuong thuc dang xuat
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // phuong thuc get Token
  Future<String?> getToken() async {
    User? user = firebaseAuth.currentUser;
    try {
      if (user != null) {
        String? userToken = await user.getIdToken(true);
        return userToken;
      } else {
        print("Tai khoan chua duoc dang nhap !");
        return null;
      }
    } catch (e) {
      print("Loi ket noi : $e");
      rethrow; // TODO : xu ly loi ket noi mang
    }
  }
}

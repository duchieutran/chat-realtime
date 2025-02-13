import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorModel {
  final String code;
  final String message;

  AuthErrorModel({required this.code, required this.message});

  static AuthErrorModel fromFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      // Login errors
      case 'invalid-email':
        return AuthErrorModel(code: e.code, message: 'Invalid email format.');
      case 'user-not-found':
        return AuthErrorModel(
            code: e.code, message: 'No user found with this email.');
      case 'wrong-password':
        return AuthErrorModel(code: e.code, message: 'Incorrect password.');
      case 'user-disabled':
        return AuthErrorModel(
            code: e.code, message: 'This account has been disabled.');
      case 'too-many-requests':
        return AuthErrorModel(
            code: e.code,
            message: 'Too many requests, please try again later.');
      case 'operation-not-allowed':
        return AuthErrorModel(
            code: e.code, message: 'Email/password login is not enabled.');
      case 'network-request-failed':
        return AuthErrorModel(
            code: e.code, message: 'Network connection error.');

      // Registration errors
      case 'email-already-in-use':
        return AuthErrorModel(
            code: e.code, message: 'The email address is already in use.');
      case 'weak-password':
        return AuthErrorModel(
            code: e.code,
            message:
                'The password is too weak. Please choose a stronger password.');
      case 'missing-android-pkg-name':
        return AuthErrorModel(
            code: e.code,
            message: 'The Android app is not properly configured.');
      case 'missing-continue-uri':
        return AuthErrorModel(code: e.code, message: 'Missing continue URI.');
      case 'invalid-continue-uri':
        return AuthErrorModel(code: e.code, message: 'Invalid continue URI.');
      case 'operation-not-allowed':
        return AuthErrorModel(
            code: e.code, message: 'Email/password sign-up is not enabled.');

      default:
        return AuthErrorModel(
            code: e.code, message: 'An error occurred. Please try again.');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String email;
  final String name;
  final String urlAvatar;
  final bool isOnline;
  final Timestamp lastSeen;
  final List<String> friends;

  Users({
    required this.uid,
    required this.email,
    required this.name,
    required this.urlAvatar,
    required this.isOnline,
    required this.lastSeen,
    required this.friends,
  });

  // func convert model to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'url': urlAvatar,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'friend': friends
    };
  }
}

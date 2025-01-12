import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String email;
  final String name;
  final String urlAvatar;
  final bool isOnline;
  final Timestamp? lastSeen;
  List<String>? friends;

  Users({
    this.uid = '',
    this.email = '',
    this.name = '',
    this.urlAvatar = '',
    this.isOnline = false,
    this.lastSeen,
    this.friends,
  });

  // Chuyển từ JSON trong Firestore thành Users
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        uid: json['uid'] ?? '',
        name: json['name'] ?? 'No Name',
        email: json['email'] ?? '',
        urlAvatar: json['urlAvatar'] ?? '',
        isOnline: json['isOnline'] ?? false,
        friends: List<String>.from(json['friends'] ?? []),
        lastSeen: json['lastSeen']);
  }

  // Chuyển UserModel thành JSON để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'urlAvatar': urlAvatar,
      'isOnline': isOnline,
      'friends': friends,
    };
  }
}

class Users {
  final String uid;
  final String email;
  String name;
  String urlAvatar;
  final bool isOnline;
  List<String>? friends;
  List<String>? friendRequests;

  Users(
      {this.uid = '',
      this.email = '',
      this.name = '',
      this.urlAvatar = '',
      this.isOnline = false,
      this.friends,
      this.friendRequests});

  // getter && setter

  // Chuyển từ JSON trong Firestore thành Users
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        uid: json['uid'] ?? '',
        name: json['name'] ?? 'No Name',
        email: json['email'] ?? '',
        urlAvatar: json['urlAvatar'] ?? '',
        isOnline: json['isOnline'] ?? false,
        friends: List<String>.from(json['friends'] ?? []),
        friendRequests: List<String>.from(json['friendRequests'] ?? []));
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
      'friendRequests': friendRequests,
    };
  }
}

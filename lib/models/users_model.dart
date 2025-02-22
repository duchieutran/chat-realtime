class Users {
  bool role;
  final String uid;
  final String email;
  String name;
  String username;
  String urlAvatar;
  List<String>? friends;
  List<String>? friendRequests;
  List<String>? groupId;

  Users(
      {this.role = false,
      this.uid = '',
      this.email = '',
      this.name = '',
      this.username = '',
      this.urlAvatar = '',
      this.friends,
      this.friendRequests,
      this.groupId});

  // Chuyển từ JSON trong Firestore thành Users
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        role: json['role'] ?? false,
        uid: json['uid'] ?? '',
        name: json['name'] ?? 'No Name',
        username: json['username'],
        email: json['email'] ?? '',
        urlAvatar: json['urlAvatar'] ?? '',
        friends: List<String>.from(json['friends'] ?? []),
        friendRequests: List<String>.from(json['friendRequests'] ?? []),
        groupId: List<String>.from(json['groupId'] ?? []));
  }

  // Chuyển UserModel thành JSON để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'urlAvatar': urlAvatar,
      'friends': friends,
      'friendRequests': friendRequests,
      'groupId': groupId,
    };
  }
}

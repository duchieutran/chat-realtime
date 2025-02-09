import 'package:chatting/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreServices {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // lưu thông tin người dùng
  saveUser({required Users user}) async {
    try {
      if (auth.currentUser != null) {
        String uid = auth.currentUser!.uid;
        await fireStore.collection("users").doc(uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.name,
          'urlAvatar': user.urlAvatar,
          'isOnline': user.isOnline,
          'friends': user.friends,
          'friendRequests': user.friendRequests,
        }, SetOptions(merge: true));
      } else {
        print("user không tồn tại!");
      }
    } catch (e) {
      rethrow;
    }
  }

  // lấy thông tin cá nhân theo uid
  Future<Users?> getUserInfo({required String uid}) async {
    try {
      DocumentSnapshot userSnapshot =
          await fireStore.collection("users").doc(uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        Users user = Users(
          uid: userData['uid'] ?? '',
          email: userData['email'] ?? '',
          name: userData['name'] ?? '',
          urlAvatar: userData['urlAvatar'] ?? '',
          isOnline: userData['isOnline'] ?? false,
          friends: List<String>.from(userData['friends'] ?? []),
          friendRequests: List<String>.from(userData['friendRequests'] ?? []),
        );

        return user;
      } else {
        print("Người dùng không tồn tại trong Firestore !");
        return null;
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin người dùng: $e");
      return null;
    }
  }

  // Hàm gửi lời mời kết bạn
  Future<void> sendFriendRequest(String receiverUid) async {
    try {
      if (auth.currentUser != null) {
        String uid = auth.currentUser!.uid;
        final receiverRef = fireStore.collection("users").doc(receiverUid);
        await receiverRef.update({
          'friendRequests': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print("Lỗi khi gửi lời mời kết bạn: $e");
    }
  }

  // hiển thị bạn bè gửi lời mời
  Stream<List<String>> listenToFriendRequests() {
    try {
      String? uid = auth.currentUser?.uid;
      return fireStore
          .collection("users")
          .doc(uid ?? "")
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return List<String>.from(snapshot.data()?['friendRequests'] ?? []);
        }
        return [];
      });
    } catch (e) {
      rethrow;
    }
  }

  // cập nhật danh sách bạn bè
  Stream<List<String>> listenToFriend() {
    try {
      String? uid = auth.currentUser?.uid;
      return fireStore.collection("users").doc(uid).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return List<String>.from(snapshot.data()?['friends'] ?? []);
        }
        return [];
      });
    } catch (e) {
      rethrow;
    }
  }

  // hàm chấp nhận
  Future<void> acceptFriendRequest(String senderUid) async {
    try {
      final userUid = auth.currentUser?.uid;
      if (userUid == null) throw Exception("Người dùng chưa đăng nhập.");

      final userRef = fireStore.collection("users").doc(userUid);
      final senderRef = fireStore.collection("users").doc(senderUid);

      await fireStore.runTransaction((transaction) async {
        // Thêm bạn mới vào danh sách của cả hai
        transaction.update(userRef, {
          'friends': FieldValue.arrayUnion([senderUid]),
          'friendRequests': FieldValue.arrayRemove([senderUid]),
        });

        transaction.update(senderRef, {
          'friends': FieldValue.arrayUnion([userUid]),
        });
      });
    } catch (e) {
      print("Lỗi khi chấp nhận lời mời kết bạn: $e");
    }
  }

  // Hàm từ chối lời mời kết bạn
  Future<void> remoteFriendRequest(String senderUid) async {
    try {
      final userUid = auth.currentUser?.uid; // Lấy UID của người dùng hiện tại
      if (userUid == null) throw Exception("Người dùng chưa đăng nhập.");

      final userRef = fireStore.collection("users").doc(userUid);
      await userRef.update({
        'friendRequests': FieldValue.arrayRemove([senderUid]),
      });
    } catch (e) {
      print("Lỗi khi từ chối lời mời kết bạn: $e");
    }
  }

  // Gửi tin nhắn giữa hai người
  Future<void> sendMessage({
    required String receiverUid,
    required String message,
  }) async {
    try {
      String senderUid = auth.currentUser!.uid;
      String chatId = getChatId(senderUid, receiverUid);
      await fireStore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .add({
        'senderUid': senderUid,
        'receiverUid': receiverUid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Lỗi khi gửi tin nhắn: $e");
    }
  }

  // Tạo nhóm chat
  Future<void> createGroupChat({
    required String groupName,
    required List<String> members,
  }) async {
    try {
      DocumentReference groupRef = await fireStore.collection("groups").add({
        'groupName': groupName,
        'members': members,
        'createdBy': auth.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Lấy ID nhóm
      String groupId = groupRef.id;

      // Cập nhật danh sách nhóm của từng thành viên
      for (String member in members) {
        await fireStore.collection("users").doc(member).update({
          'groups': FieldValue.arrayUnion([groupId])
        });
      }
    } catch (e) {
      print("Lỗi khi tạo nhóm: $e");
    }
  }

  // Gửi tin nhắn trong nhóm
  Future<void> sendGroupMessage({
    required String groupId,
    required String message,
  }) async {
    try {
      String senderUid = auth.currentUser!.uid;
      await fireStore
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .add({
        'senderUid': senderUid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Lỗi khi gửi tin nhắn nhóm: $e");
    }
  }

  // Nhận tin nhắn trong nhóm theo thời gian thực
  Stream<List<Map<String, dynamic>>> getGroupMessages(String groupId) {
    return fireStore
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Nhận tin nhắn theo thời gian thực
  Stream<List<Map<String, dynamic>>> getMessages(String receiverUid) {
    String senderUid = auth.currentUser!.uid;
    String chatId = getChatId(senderUid, receiverUid);

    return fireStore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Tạo chatId duy nhất cho cuộc trò chuyện giữa hai người
  String getChatId(String uid1, String uid2) {
    return (uid1.compareTo(uid2) < 0) ? "$uid1\_$uid2" : "$uid2\_$uid1";
  }
}

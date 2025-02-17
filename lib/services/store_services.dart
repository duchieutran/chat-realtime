import 'package:chatting/models/users_model.dart';
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
        bool available = await isUsernameAvailable(user.username);
        if (!available) {
          print("Username đã tồn tại!");
          return;
        }

        await fireStore.collection("users").doc(uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.name,
          'username': user.username, // Thêm username vào
          'urlAvatar': user.urlAvatar,
          'friends': user.friends,
          'friendRequests': user.friendRequests,
        }, SetOptions(merge: true));
      } else {
        print("User không tồn tại!");
      }
    } catch (e) {
      rethrow;
    }
  }

  // kiểm tra xem username có trùng không
  Future<bool> isUsernameAvailable(String username) async {
    var query = await fireStore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    // Nếu không có tài liệu nào hoặc nếu tài liệu tìm thấy có ID là của user hiện tại
    return query.docs.isEmpty ||
        query.docs.every((doc) => doc.id == auth.currentUser!.uid);
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
  Stream<List<String>> listenToFriendRequests({String? uidParam}) {
    try {
      String? uid = auth.currentUser?.uid;
      return fireStore
          .collection("users")
          .doc(uidParam ?? uid)
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
}

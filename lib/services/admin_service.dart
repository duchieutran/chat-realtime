import 'package:chatting/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm lấy tất cả người dùng
  Future<List<Users>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      List<Users> users = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Users.fromJson(data);
      }).toList();

      return users;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  // Lấy số lượng người dùng
  Future<int> getUserCount() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.size; // Trả về số lượng tài liệu trong collection
    } catch (e) {
      print("Error fetching user count: $e");
      return 0; // Trả về 0 nếu có lỗi
    }
  }

  // Cập nhật vai trò của người dùng (true: admin, false: user)
  Future<void> updateUserRole(String uid, bool isAdmin) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'role': isAdmin, // Cập nhật trường role
      });
      print("User role updated successfully!");
    } catch (e) {
      print("Error updating user role: $e");
    }
  }
}

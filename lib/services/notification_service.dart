import 'package:chatting/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final CollectionReference _notificationsRef = FirebaseFirestore.instance.collection('notifications');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gửi thông báo từ Admin (có thể gửi cho tất cả hoặc một số người nhất định)
  Future<void> sendNotification({
    required String content,
    required String adminUid,
    List<String>? receivers,
  }) async {
    final notification = NotificationModel(
      id: '',
      content: content,
      createdAt: Timestamp.now(),
      seenBy: [],
      createdBy: adminUid,
      isActive: true,
      receivers: receivers,
    );
    await _notificationsRef.add(notification.toMap());
  }

  /// Đánh dấu thông báo là đã xem bởi một user
  Future<void> markAsSeen(String notificationId, String userId) async {
    await _notificationsRef.doc(notificationId).update({
      'seenBy': FieldValue.arrayUnion([userId])
    });
  }

  /// Lấy danh sách thông báo còn hiệu lực (có thể lọc theo user nhận)
  Stream<List<NotificationModel>> getActiveNotifications() {
    Query query = _notificationsRef.orderBy('createdAt', descending: true);
    if (_auth.currentUser != null) {
      query = query.where('receivers', arrayContainsAny: [null, _auth.currentUser!.uid]);
    }

    return query
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList());
  }

  /// Lấy tất cả thông báo (không phân biệt trạng thái isActive)
  Stream<List<NotificationModel>> getAllNotifications() {
    return _notificationsRef
        .orderBy('createdAt', descending: true) // Sắp xếp theo thời gian mới nhất
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList());
  }

  /// Lấy thông báo cuối cùng (mới nhất) còn hiệu lực
  Future<NotificationModel?> getLatestActiveNotification() async {
    final snapshot = await _notificationsRef
        .where('isActive', isEqualTo: true)
        .where('receivers', isNull: true) // Lọc thông báo không có receivers (null)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return NotificationModel.fromFirestore(snapshot.docs.first);
    }

    // Nếu không tìm thấy, kiểm tra thông báo có receivers là []
    final snapshotAll = await _notificationsRef
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get(); // Lấy tất cả để kiểm tra thủ công

    for (var doc in snapshotAll.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['receivers'] is List && (data['receivers'] as List).isEmpty) {
        return NotificationModel.fromFirestore(doc);
      }
    }

    return null;
  }

  /// Cập nhật trạng thái thông báo (cho phép kích hoạt hoặc vô hiệu hóa)
  Future<void> updateNotificationStatus(String notificationId, bool isActive) async {
    await _notificationsRef.doc(notificationId).update({'isActive': isActive});
  }

  /// Get the total number of notifications
  Future<int> getNotificationCount() async {
    final snapshot = await _notificationsRef.get();
    return snapshot.docs.length;
  }
}

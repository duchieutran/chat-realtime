import 'package:chatting/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final CollectionReference _notificationsRef =
      FirebaseFirestore.instance.collection('notifications');

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
  Stream<List<NotificationModel>> getActiveNotifications({String? userId}) {
    Query query = _notificationsRef
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (userId != null) {
      query = query.where('receivers', arrayContainsAny: [null, userId]);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc))
        .toList());
  }

  /// Lấy thông báo cuối cùng (mới nhất) còn hiệu lực
  Future<NotificationModel?> getLatestActiveNotification() async {
    final snapshot = await _notificationsRef
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return NotificationModel.fromFirestore(snapshot.docs.first);
    }
    return null;
  }

  /// Cập nhật trạng thái thông báo (cho phép kích hoạt hoặc vô hiệu hóa)
  Future<void> updateNotificationStatus(
      String notificationId, bool isActive) async {
    await _notificationsRef.doc(notificationId).update({'isActive': isActive});
  }
}

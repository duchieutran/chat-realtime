import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String content;
  final Timestamp createdAt;
  final List<String> seenBy;
  final String createdBy;
  final bool isActive;
  final List<String>? receivers; // Danh sách người nhận (null = gửi cho tất cả)

  NotificationModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.seenBy,
    required this.createdBy,
    required this.isActive,
    this.receivers, // Nếu null => gửi cho tất cả
  });

  /// Chuyển đổi từ Firestore DocumentSnapshot thành NotificationModel
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      content: data['content'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      seenBy: List<String>.from(data['seenBy'] ?? []),
      createdBy: data['createdBy'] ?? '',
      isActive: data['isActive'] ?? true,
      receivers: data['receivers'] != null
          ? List<String>.from(data['receivers'])
          : null,
    );
  }

  /// Chuyển đổi thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'createdAt': createdAt,
      'seenBy': seenBy,
      'createdBy': createdBy,
      'isActive': isActive,
      'receivers': receivers,
    };
  }
}

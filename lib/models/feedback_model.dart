import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id; // ID của feedback (Firestore document ID)
  final String uid; // UID của người gửi
  final String senderName; // Tên người gửi
  final String title; // Tiêu đề phản hồi
  final String content; // Nội dung phản hồi
  final String category; // Loại phản hồi (Bug, Suggestion, Other)
  final String status; // Trạng thái (Pending, Reviewed, Resolved)
  final Timestamp createdAt; // Thời gian tạo phản hồi

  FeedbackModel({
    required this.id,
    required this.uid,
    required this.senderName,
    required this.title,
    required this.content,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  // Chuyển từ Firestore DocumentSnapshot -> FeedbackModel
  factory FeedbackModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedbackModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      senderName: data['senderName'] ?? 'Unknown',
      title: data['title'] ?? 'No Title',
      content: data['content'] ?? 'No Content',
      category: data['category'] ?? 'Other',
      status: data['status'] ?? 'Pending',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Chuyển từ FeedbackModel -> Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'senderName': senderName,
      'title': title,
      'content': content,
      'category': category,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

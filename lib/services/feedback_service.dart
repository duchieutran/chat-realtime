import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/feedback_model.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Gửi phản hồi (User)
  Future<void> sendFeedback({
    required String title,
    required String content,
    required String category,
    required String senderName,
  }) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final feedback = FeedbackModel(
      id: '',
      uid: uid,
      senderName: senderName,
      title: title,
      content: content,
      category: category,
      status: 'Pending',
      // Mặc định là chưa xử lý
      createdAt: Timestamp.now(),
    );

    await _firestore.collection('feedbacks').add(feedback.toMap());
  }

  /// Lấy số lượng feedback
  Future<int> getFeedbacksService() async {
    final snapshot = await _firestore.collection('feedbacks').get();
    return snapshot.docs.length;
  }

  /// Lấy danh sách phản hồi của người dùng (User)
  Stream<List<FeedbackModel>> getUserFeedbacks() {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return _firestore
        .collection('feedbacks')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FeedbackModel.fromDocument(doc)).toList());
  }

  /// Lấy tất cả phản hồi của người dùng (Admin)
  Stream<List<FeedbackModel>> getAllFeedbacks() {
    return _firestore
        .collection('feedbacks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FeedbackModel.fromDocument(doc)).toList());
  }

  /// Lấy phản hồi theo trạng thái (Admin)
  Stream<List<FeedbackModel>> getFeedbacksByStatus(String status) {
    return _firestore
        .collection('feedbacks')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FeedbackModel.fromDocument(doc)).toList());
  }

  /// Cập nhật trạng thái phản hồi (Admin)
  Future<void> updateFeedbackStatus(String feedbackId, String newStatus) async {
    await _firestore.collection('feedbacks').doc(feedbackId).update({
      'status': newStatus,
    });
  }

  /// Xóa phản hồi (Admin)
  Future<void> deleteFeedback(String feedbackId) async {
    await _firestore.collection('feedbacks').doc(feedbackId).delete();
  }
}

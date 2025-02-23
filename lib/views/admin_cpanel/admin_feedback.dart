import 'package:chatting/models/feedback_model.dart';
import 'package:chatting/services/feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminFeedBack extends StatefulWidget {
  const AdminFeedBack({super.key});

  @override
  State<AdminFeedBack> createState() => _AdminFeedBackState();
}

class _AdminFeedBackState extends State<AdminFeedBack> {
  final FeedbackService _feedbackService = FeedbackService();

  void _markAsResolved(String feedbackId) {
    _feedbackService.updateFeedbackStatus(feedbackId, 'Resolved');
  }

  void _deleteFeedback(String feedbackId) {
    _feedbackService.deleteFeedback(feedbackId);
  }

  void _showFeedbackDetails(FeedbackModel feedback) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: Text(feedback.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feedback.content, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Text("Ngày tạo: ${DateFormat('HH:mm dd/MM/yyyy').format(feedback.createdAt.toDate())}",
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              Text("Người gửi: ${feedback.senderName}", style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Đóng", style: TextStyle(color: Colors.white)),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Feedbacks', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff44518a),
      ),
      backgroundColor: const Color(0xff44518a),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<FeedbackModel>>(
          stream: _feedbackService.getAllFeedbacks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No feedbacks found", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              );
            }

            final feedbacks = snapshot.data!;

            return ListView.builder(
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = feedbacks[index];
                final isResolved = feedback.status == 'Resolved';
                final statusIcon = Icon(
                  isResolved ? Icons.check_circle : Icons.pending,
                  color: isResolved ? Colors.green : Colors.yellow,
                );
                final formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(feedback.createdAt.toDate());

                return Card(
                  color: const Color(0xff596def),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () => _showFeedbackDetails(feedback),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  feedback.title,
                                  style:
                                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              statusIcon,
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text("Category: ${feedback.category}",
                              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                          Text("Status: ${feedback.status}",
                              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                          Text("Sent: $formattedDate",
                              style: const TextStyle(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () => _markAsResolved(feedback.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Resolve",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              ),
                              ElevatedButton(
                                onPressed: () => _deleteFeedback(feedback.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

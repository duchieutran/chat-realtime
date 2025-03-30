import 'package:chatting/models/feedback_model.dart';
import 'package:chatting/services/feedback_service.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key, required this.senderUserName});

  final String senderUserName;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackService _feedbackService = FeedbackService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'Bug Report';

  final List<String> categories = [
    'Bug Report',
    'Feature Request',
    'General Feedback',
  ];

  void _sendFeedback() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields',
              style: TextStyle(fontWeight: FontWeight.w500)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await _feedbackService.sendFeedback(
      title: _titleController.text,
      content: _contentController.text,
      category: _selectedCategory,
      senderName: widget.senderUserName,
    );

    _titleController.clear();
    _contentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feedback sent successfully',
            style: TextStyle(fontWeight: FontWeight.w500)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Feedback',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Submit Feedback",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat,
                          style: TextStyle(fontWeight: FontWeight.w500))))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Category',
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 12),

            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Title',
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 12),

            // Feedback Content
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Feedback Content',
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 12),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendFeedback,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Submit Feedback",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 20),

            // My Feedback List
            const Text(
              "My Feedback",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: StreamBuilder<List<FeedbackModel>>(
                stream: _feedbackService.getUserFeedbacks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("No feedbacks found",
                            style: TextStyle(fontWeight: FontWeight.w500)));
                  }

                  final feedbacks = snapshot.data!;

                  return ListView.builder(
                    itemCount: feedbacks.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbacks[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(feedback.title,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category: ${feedback.category}",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500)),
                              Text("Status: ${feedback.status}",
                                  style: TextStyle(
                                      color: feedback.status == "Resolved"
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                "Sent: ${feedback.createdAt.toDate()}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            feedback.status == "Resolved"
                                ? Icons.check_circle
                                : Icons.pending_actions,
                            color: feedback.status == "Resolved"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chatting/models/notification_model.dart';
import 'package:chatting/services/notification_service.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(size, context),
          Expanded(
            child: StreamBuilder<List<NotificationModel>>(
              stream: _notificationService.getActiveNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No notifications available"));
                }

                final notifications = snapshot.data!;
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final bool isSeen =
                        notification.seenBy.contains(currentUserId);

                    return NotificationCard(
                        notification: notification,
                        isSeen: isSeen,
                        onTap: () {
                          showNotificationPopup(size, context, notification);
                          _notificationService.markAsSeen(notification.id);
                        });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Size size, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 16, right: 16, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      width: size.width,
      height: size.height * 0.08,
      decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.grey40,
              spreadRadius: 5,
              blurRadius: 15,
              offset: Offset(0, 0), // Bóng đều ở cả 4 cạnh
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // back
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.dark,
            ),
          ),
          Text(
            "Notification",
            style: TextStyle(
                color: AppColors.dark,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          Icon(
            Icons.arrow_back_ios,
            color: AppColors.light,
          )
        ],
      ),
    );
  }

  void showNotificationPopup(
      Size size, BuildContext context, NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Notification",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting message
              const Text(
                "Hello! You have a new notification.",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),

              // Notification content
              Container(
                padding: const EdgeInsets.all(12),
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  notification.content,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
              ),
              const SizedBox(height: 12),

              // Time sent
              Text(
                "Sent at: ${DateFormat('dd/MM/yyyy HH:mm').format(notification.createdAt.toDate())}",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
              const SizedBox(height: 4),

              // Sender info
              const Text(
                "Sent by: Admin",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final bool isSeen;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.isSeen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(2, 4), // Hiệu ứng bóng 3D
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nội dung thông báo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Tiêu đề "Thông báo"
                  Text(
                    "Notification",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Nội dung thông báo (cắt nếu quá dài)
                  Text(
                    notification.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.dark,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),

                  // Thời gian gửi
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format(notification.createdAt.toDate()),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // isSeen
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: (isSeen)
                  ? SizedBox()
                  : const Icon(Icons.circle, color: Colors.red, size: 15),
            ),
          ],
        ),
      ),
    );
  }
}

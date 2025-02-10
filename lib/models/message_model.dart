import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final List<String> seenBy; // Danh sách người đã xem

  MessageModel({
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.seenBy = const [],
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'],
      text: map['text'],
      timestamp: map['timestamp'],
      seenBy: List<String>.from(map['seenBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'seenBy': seenBy,
    };
  }
}

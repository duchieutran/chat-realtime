import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageModel {
  final String senderID;
  final String content;
  final Timestamp lastSend;

  LastMessageModel({
    required this.senderID,
    required this.content,
    required this.lastSend,
  });

  // chuyen tu map => model
  factory LastMessageModel.fromMap(Map<String, dynamic> data) =>
      LastMessageModel(
          senderID: data['senderID'],
          content: data['content'],
          lastSend: data['timestamp']);

  // chuyen tu model => map
  Map<String, dynamic> toMap() => {
        'senderID': senderID,
        'content': content,
        'timestamp': lastSend,
      };
}

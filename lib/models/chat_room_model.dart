import 'package:chatting/models/last_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String chatId;
  final String urlAvatar;
  final String uidAdmin;
  final String name;
  final String type;
  final List<String> members;
  final LastMessageModel? lastMessage;
  final Timestamp createdAt;

  ChatRoomModel({
    required this.chatId,
    required this.urlAvatar,
    required this.uidAdmin,
    required this.name,
    required this.type,
    required this.members,
    this.lastMessage,
    required this.createdAt,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      chatId: map['chatId'],
      urlAvatar: map['urlAvatar'],
      uidAdmin: map['uidAdmin'],
      name: map['name'],
      type: map['type'],
      members: List<String>.from(map['members']),
      lastMessage: map['lastMessage'] != null
          ? LastMessageModel.fromMap(map['lastMessage'])
          : null,
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'urlAvatar': urlAvatar,
      'uidAdmin': uidAdmin,
      'name': name,
      'type': type,
      'members': members,
      'lastMessage': lastMessage?.toMap(),
      'createdAt': createdAt,
    };
  }
}

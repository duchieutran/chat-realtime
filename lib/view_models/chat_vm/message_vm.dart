import 'package:chatting/models/chat_room_model.dart';
import 'package:chatting/models/message_model.dart';
import 'package:chatting/services/chat_service.dart';
import 'package:chatting/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageViewModel extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final StoreServices _storeServices = StoreServices();
  final ChatService _chatService = ChatService();

  Stream<List<ChatRoomModel>>? listRoom;
  List<ChatRoomModel> cachedRooms = []; // Lưu dữ liệu cũ
  List<MessageModel> _messages = [];
  bool _isLoading = true;

  // hàm tạo đoạn chat riêng tư
  void createChatRoom({required String uidName}) {
    _chatService.createChat("", "", [auth.currentUser!.uid, uidName]);
  }

  void createChatRoomGroup(
      {required String urlAvatar,
      required String name,
      required List<String> members}) {
    members.insert(0, auth.currentUser!.uid);
    _chatService.createChat(urlAvatar, name, members, isGroup: true);
  }

  // hàm hiển thị ngay đầu tiên
  Future<void> fetchInitialRooms() async {
    try {
      var snapshot = await fireStore
          .collection("chats")
          .where("members", arrayContains: auth.currentUser!.uid)
          .get();

      cachedRooms = snapshot.docs.map((doc) {
        return ChatRoomModel.fromMap(doc.data());
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Lỗi khi lấy dữ liệu ban đầu: $e");
    }
  }

  // hàm hiển thị đoạn chat
  void getChatRoom() async {
    await fetchInitialRooms();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatService.getUserChats(auth.currentUser!.uid);
      notifyListeners();
    });
  }

  /// Lắng nghe tin nhắn trong đoạn chat
  Stream<List<MessageModel>> getMessageStream(String chatId) {
    return _chatService.getMessages(chatId);
  }

  /// Gửi tin nhắn mới
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    final message = MessageModel(
      senderId: senderId,
      text: text,
      timestamp: Timestamp.now(),
    );
    await _chatService.sendMessage(chatId, message);
  }

  /// Đánh dấu tin nhắn đã xem
  Future<void> markMessageAsSeen(
      String chatId, String messageId, String userId) async {
    await _chatService.markMessageAsSeen(chatId, messageId, userId);
  }
}

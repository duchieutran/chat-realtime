import 'package:chatting/models/chat_room_model.dart';
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

  // hàm tạo đoạn chat riêng tư
  void createChatRoom(
      {required String urlAvatar,
      required String name,
      required String uidName}) {
    _chatService.createChat(urlAvatar, name, [auth.currentUser!.uid, uidName]);
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
    await fetchInitialRooms(); // Hàm lấy dữ liệu từ Firestore

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Nhận tin nhắn theo thời gian thực
  Stream<List<Map<String, dynamic>>> getMessages(String receiverUid) {
    return _storeServices.getMessages(receiverUid);
  }

  // Gửi tin nhắn
  Future<void> sendMessage(String receiverUid, String message) async {
    try {
      String senderUid = auth.currentUser!.uid;
      String chatId = _storeServices.getChatId(senderUid, receiverUid);

      await fireStore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .add({
        "senderUid": senderUid,
        "receiverUid": receiverUid,
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      print("Lỗi khi gửi tin nhắn: $e");
    }
  }
}

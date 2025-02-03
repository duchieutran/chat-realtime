import 'package:chatting/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageViewModel extends ChangeNotifier {
  final StoreServices _storeServices = StoreServices();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> messages = [];

  // Nhận tin nhắn theo thời gian thực
  Stream<List<Map<String, dynamic>>> getMessages(String receiverUid) {
    return _storeServices.getMessages(receiverUid);
  }

  // Gửi tin nhắn
  Future<void> sendMessage(String receiverUid, String message) async {
    try {
      String senderUid = auth.currentUser!.uid;
      String chatId = _storeServices.getChatId(senderUid, receiverUid);

      await fireStore.collection("chats").doc(chatId).collection("messages").add({
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

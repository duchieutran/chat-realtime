import 'package:chatting/models/chat_room_model.dart';
import 'package:chatting/models/last_message_model.dart';
import 'package:chatting/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // Khai bao
  final FirebaseFirestore store = FirebaseFirestore.instance;

  // ham tao doan chat [isGroup = true ? 'group' : 'private']
  Future<String> createChat(String urlAvatar, String name, List<String> members,
      {bool isGroup = false}) async {
    final chatRef = store.collection('chats').doc();
    LastMessageModel lastMessageNew =
        LastMessageModel(senderID: "", content: "", lastSend: Timestamp.now());
    ChatRoomModel newChat = ChatRoomModel(
      chatId: chatRef.id,
      urlAvatar: urlAvatar,
      name: name,
      type: isGroup ? 'group' : 'private',
      members: members,
      lastMessage: lastMessageNew,
      createdAt: Timestamp.now(),
    );
    await chatRef.set(newChat.toMap());
    return chatRef.id;
  }

  // lay danh sach chat
  Stream<List<ChatRoomModel>> getUserChats(String userId) {
    return store
        .collection('chats')
        .where('members', arrayContains: userId)
        .orderBy('lastMessage.timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoomModel.fromMap(doc.data()))
            .toList());
  }

  /// Gửi tin nhắn mới
  Future<void> sendMessage(String chatId, MessageModel message) async {
    final messageRef = store
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .doc(); // ID tự động

    LastMessageModel lastMessageModel = LastMessageModel(
        senderID: message.senderId,
        content: message.text,
        lastSend: message.timestamp);

    final lastMessage = store.collection('chats').doc(chatId);

    await messageRef.set(message.toMap());
    await lastMessage.update({'lastMessage': lastMessageModel.toMap()});
  }

  /// Lắng nghe danh sách tin nhắn trong một đoạn chat
  Stream<List<MessageModel>> getMessages(String chatId) {
    return store
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  /// Đánh dấu tin nhắn đã xem
  Future<void> markMessageAsSeen(
      String chatId, String messageId, String userId) async {
    final messageRef = store
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    await messageRef.update({
      'seenBy': FieldValue.arrayUnion([userId]),
    });
  }

  /// Lắng nghe trạng thái của một tin nhắn cụ thể
// Stream<MessageModel> listenToMessage(String chatId, String messageId) {
//   return store
//       .collection('messages')
//       .doc(chatId)
//       .collection('messages')
//       .doc(messageId)
//       .snapshots()
//       .map((doc) => MessageModel.fromMap(doc.data()!));
// }
}

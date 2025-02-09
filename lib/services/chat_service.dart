import 'package:chatting/models/chat_room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // Khai bao
  final FirebaseFirestore store = FirebaseFirestore.instance;

  // ham tao doan chat [isGroup = true ? 'group' : 'private']
  Future<String> createChat(String urlAvatar, String name, List<String> members,
      {bool isGroup = false}) async {
    final chatRef = store.collection('chats').doc();
    ChatRoomModel newChat = ChatRoomModel(
      chatId: chatRef.id,
      urlAvatar: urlAvatar,
      name: name,
      type: isGroup ? 'group' : 'private',
      members: members,
      lastMessage: null,
      createdAt: Timestamp.now(),
    );
    await chatRef.set(newChat.toMap());
    return chatRef.id;
  }

  // lay danh sach chat
  Stream<List<ChatRoomModel>> getUserChats(String userId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: userId)
        .orderBy('lastMessage.timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoomModel.fromMap(doc.data()))
            .toList());
  }
}

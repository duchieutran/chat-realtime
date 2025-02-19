import 'package:chatting/models/chat_room_model.dart';
import 'package:chatting/models/last_message_model.dart';
import 'package:chatting/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // Khai bao
  final FirebaseFirestore store = FirebaseFirestore.instance;

  // ham tao doan chat [isGroup = true ? 'group' : 'private']
  Future<String> createChat(String urlAvatar, String name, List<String> members,
      {bool isGroup = false, String uidAdmin = ""}) async {
    final chatRef = store.collection('chats').doc();
    // tin nhan cuoi cung
    LastMessageModel lastMessageNew = LastMessageModel(
        senderID: "", content: "Say hi ! ", lastSend: Timestamp.now());
    // model phong chat
    ChatRoomModel newChat = ChatRoomModel(
      chatId: chatRef.id,
      urlAvatar: urlAvatar,
      uidAdmin: uidAdmin,
      name: name,
      type: isGroup ? 'group' : 'private',
      members: members,
      lastMessage: lastMessageNew,
      createdAt: Timestamp.now(),
    );
    await chatRef.set(newChat.toMap());
    return chatRef.id;
  }

  // hàm update group
  Future<void> updateGroup(
      {required chatUID,
      required String urlAvatar,
      required String name,
      required List<String> members}) async {
    try {
      final chatRef = store.collection('chats').doc(chatUID);

      Map<String, dynamic> dataToUpdate = {};

      dataToUpdate['name'] = name;
      dataToUpdate['urlAvatar'] = urlAvatar;
      dataToUpdate['members'] = members;

      if (dataToUpdate.isNotEmpty) {
        await chatRef.update(dataToUpdate);
      }
    } catch (e) {
      print("Lỗi khi cập nhật chat: $e");
      throw Exception("Không thể cập nhật thông tin chat");
    }
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

  // Gửi tin nhắn mới
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

  // Lắng nghe danh sách tin nhắn trong một đoạn chat
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

  // get Info doan chat
  Future<List<String>> listUIDGroup({required String uidGroup}) async {
    try {
      final chatRef = store.collection('chats').doc(uidGroup);
      final docSnapshot = await chatRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('members')) {
          List<dynamic> members = data['members'];
          return members.cast<String>();
        }
      }
      return [];
    } catch (e) {
      print("Lỗi khi lấy danh sách UID: $e");
      throw Exception("Không thể lấy danh sách UID của nhóm");
    }
  }
}

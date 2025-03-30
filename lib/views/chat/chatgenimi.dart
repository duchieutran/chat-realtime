import 'dart:convert';

import 'package:chatting/services/chatgenimi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatGenimi extends StatefulWidget {
  const ChatGenimi({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatGenimi> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  final GeminiService _geminiService = GeminiService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // Lưu lịch sử chat vào SharedPreferences
  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String messagesJson = jsonEncode(_messages);
    await prefs.setString('chat_history', messagesJson);
  }

  // Tải lịch sử chat từ SharedPreferences
  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? messagesJson = prefs.getString('chat_history');

    if (messagesJson != null) {
      List<dynamic> decodedList = jsonDecode(messagesJson);

      setState(() {
        _messages.clear();
        _messages
            .addAll(decodedList.map((item) => Map<String, String>.from(item)));
      });
    }
  }

  String buildChatHistory() {
    int maxMessages = 5; // Chỉ lấy 5 tin nhắn cuối
    List<Map<String, String>> recentMessages = _messages.length > maxMessages
        ? _messages.sublist(_messages.length - maxMessages)
        : _messages;

    return recentMessages.map((msg) => msg['text']).join("\n");
  }

  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom(); // Cuộn xuống sau khi gửi tin nhắn

    String chatHistory = buildChatHistory();
    String response =
        await _geminiService.sendMessage("$chatHistory\n$message");

    setState(() {
      _messages.add({'sender': 'gemini', 'text': response});
      _isTyping = false;
    });

    _scrollToBottom();
    // _saveChatHistory();
  }

  // Hiển thị hộp thoại xác nhận khi nhấn back
  Future<bool> _onWillPop() async {
    return await showModalBottomSheet<bool>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Lưu đoạn chat?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Bạn có muốn lưu lại cuộc trò chuyện trước khi thoát?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // Thoát mà không lưu
                        },
                        icon: Icon(Icons.close, color: Colors.white),
                        label: Text("Không"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _saveChatHistory(); // Lưu tin nhắn trước khi thoát
                          Navigator.of(context).pop(true);
                        },
                        icon: Icon(Icons.save, color: Colors.white),
                        label: Text("Lưu & Thoát"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gemini Chat"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(10),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Gemini đang nhập...",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  bool isUser = _messages[index]['sender'] == 'user';
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                Colors.grey[400], // Màu nền avatar bot
                            child: Icon(Icons.smart_toy, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isUser ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: isUser
                                    ? Radius.circular(16)
                                    : Radius.circular(4),
                                bottomRight: isUser
                                    ? Radius.circular(4)
                                    : Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _messages[index]['text']!,
                                  style: TextStyle(
                                    color:
                                        isUser ? Colors.white : Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "10:30 AM", // Giả lập timestamp
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type input ...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

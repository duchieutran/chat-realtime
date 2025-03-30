import 'dart:convert';

import 'package:dio/dio.dart';

class GeminiService {
  static const String apiKey = "AIzaSyBaqJREDvuilmhP7t219OAlqLKdob1g9dU";
  static const String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<String> sendMessage(String message) async {
    try {
      Response response = await _dio.post(
        "?key=$apiKey",
        data: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        var text =
            response.data["candidates"][0]["content"]["parts"][0]["text"];
        return text ?? "Không có phản hồi từ Gemini.";
      } else {
        return "Lỗi: ${response.statusCode} - ${response.data}";
      }
    } catch (e) {
      return "Lỗi khi gửi yêu cầu: $e";
    }
  }
}

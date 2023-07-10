import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_gpt_ai/constants/api_consts.dart';

class ApiService {
  //Send Message fct
  static Future<String> sendMessage({required String message}) async {
    final url = Uri.parse('$BASE_URL//v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $API_KEY',
    };

    var body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": message}
      ],
      "temperature": 0.7
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }

      List<dynamic> chatList = [];
      late String messageContent;
      if (jsonResponse['choices'].length > 0) {
        messageContent = jsonResponse['choices'][0]['message']['content'];
        print(messageContent);

        // chatList = List.generate(
        //   jsonResponse['choices'].length,
        //   (index) => ChatModel(
        //     msg: messageContent,
        //     chatIndex: 1,
        //   ),
        // );

        print("Response messege is: $messageContent");
      }
      return messageContent;
      print('Response status: ${response.statusCode}');
    } catch (error) {
      rethrow;
    }
  }
}

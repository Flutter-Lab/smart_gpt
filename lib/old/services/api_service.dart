import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_gpt_ai/constants/api_consts.dart';

class ApiService {
  //Send Message fct
  static Future<String> sendMessage({required String message}) async {
    final url = Uri.parse('$baseUrl//v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
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

      late String messageContent;
      if (jsonResponse['choices'].length > 0) {
        messageContent = jsonResponse['choices'][0]['message']['content'];
        // print(messageContent);
        // print("Response messege is: $messageContent");
      }
      return messageContent;
    } catch (error) {
      rethrow;
    }
  }
}

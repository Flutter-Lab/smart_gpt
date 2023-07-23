import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gpt_ai/constants/api_consts.dart';

class ApiService {
  //Send Message fct
  static Future<String> sendMessage({
    required List<Map<String, String>> contextList,
  }) async {
    final url = Uri.parse('$baseUrl/v1/chat/completions');

    String apiKey = await getApiKey();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    var body = jsonEncode({
      "model": "gpt-3.5-turbo",
      // "model": "gpt-3.5-turbo-0301",

      "messages": contextList,
      "temperature": 0.7
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // Decode the response body bytes using utf8.decode
      String responseBody = utf8.decode(response.bodyBytes);

      Map jsonResponse = jsonDecode(responseBody);
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

  static Future<String> getApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('userAPI');

    if (apiKey == null) {
      //Generate API Key for User and Set 'apiKey' Value
      apiKey = await getAndUpdateApiKey();

      prefs.setString('userAPI', apiKey!);

      return apiKey;
    } else {
      return apiKey;
    }
  }

  static Future<String?> getAndUpdateApiKey() async {
    final CollectionReference apiListCollection =
        FirebaseFirestore.instance.collection('api_list');

    final QuerySnapshot noLastUsedSnapshot =
        await apiListCollection.where('last_used', isNull: true).get();

    if (noLastUsedSnapshot.docs.isNotEmpty) {
      print('Found non last_used doc');
      final DocumentSnapshot apiKeyDoc = noLastUsedSnapshot.docs.first;
      await apiKeyDoc.reference.update({'last_used': DateTime.now()});
      print(apiKeyDoc['api_key']);
      return apiKeyDoc['api_key'];
    } else {
      print('Not found non last_used doc');
      final QuerySnapshot allKeysSnapshot =
          await apiListCollection.orderBy('last_used').limit(1).get();

      if (allKeysSnapshot.docs.isNotEmpty) {
        final DocumentSnapshot oldestApiKeyDoc = allKeysSnapshot.docs.first;
        final String oldestApiKey = oldestApiKeyDoc['api_key'];
        await oldestApiKeyDoc.reference.update({'last_used': DateTime.now()});
        print(oldestApiKey);
        return oldestApiKey;
      } else {
        return null;
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/models/chat_model.dart';

import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();

  List<ChatModel> chatList = [];

  bool isTypingStatus = false;

  List<ChatModel> get getCurrentModel {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers({required String msg}) async {
    chatList.addAll(await ApiService.sendMessage(message: msg));
    notifyListeners();
  }

  void changeTypingStatus(bool currentStatus) {
    isTypingStatus = currentStatus;
    notifyListeners();
  }
}

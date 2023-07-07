// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:smart_gpt_ai/models/chat_model.dart';

// import '../services/api_service.dart';

// class ChatProvider with ChangeNotifier {
//   TextEditingController textEditingController = TextEditingController();

//   List<ChatModel> currentChatList = [];
//   List<Map<String, dynamic>> conversation = [];

//   bool isTypingStatus = false;

//   List<ChatModel> get getCurrentModel {
//     return currentChatList;
//   }

//   void addUserMessage({required String msg}) {
//     currentChatList.add(ChatModel(msg: msg, chatIndex: 0));
//     notifyListeners();
//   }

//   Future<void> sendMessageAndGetAnswers({required String msg}) async {
//     currentChatList.addAll(await ApiService.sendMessage(message: msg));
//     notifyListeners();
//   }

//   void changeTypingStatus(bool currentStatus) {
//     isTypingStatus = currentStatus;
//     notifyListeners();
//   }

//   void updateChatList(List<ChatModel> chatModelList) {
//     currentChatList = chatModelList;
//     notifyListeners();
//   }

//   Future<List<Map<String, dynamic>>> getAllChatList() async {
//     List<Map<String, dynamic>> allChatList = [];

//     final chatBoxHive = await Hive.openBox('chat_box');

//     final data = chatBoxHive.keys.map((key) {
//       final item = chatBoxHive.get(key);
//       return {"chat_list": item["chat_list"], "time": item["time"]};
//     }).toList();

//     // allChatList = data.reversed.toList();
//     allChatList = data;
//     notifyListeners();

//     // print('All Chat list Got');
//     return allChatList;
//   }
// }

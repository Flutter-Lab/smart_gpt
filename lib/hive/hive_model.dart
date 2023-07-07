// ignore_for_file: unused_local_variable

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ChatListHive {
  static List<Map<String, dynamic>> chatList = [];

  static var chatBoxHive = Hive.box('chat_box');

  // static List<Map<String, dynamic>> getAllChatList() {
  //   List<Map<String, dynamic>> allChatList = [];

  //   // final box = await Hive.openBox('chat_box');

  //   final data = chatBoxHive.keys.map((key) {
  //     final item = chatBoxHive.get(key);
  //     return {"key": key, "chat_list": item["chat_list"]};
  //   }).toList();

  //   allChatList = data.reversed.toList();

  //   print('All Chat list Got');
  //   return allChatList;
  // }

  static Future<void> addChatToHiveDB(
      List<Map<String, dynamic>> chatList, int? chatIndex) async {
    Map<String, dynamic> item = {
      'chat_list': chatList,
      'time': getCurrentDateTime(),
    };

    final box = await Hive.openBox('chat_box');

    // // Shift existing items to higher keys
    // for (var i = box.length - 1; i >= 0; i--) {
    //   if (box.get(i) != null) {
    //     var currentItem = box.get(i);
    //     box.put(i + 1, currentItem);
    //   }
    // }

    // box.add(item);

    if (chatIndex != null) {
      await box.put(chatIndex, item);
    } else {
      await box.add(item);
    }

    print('Current Chat is added to Hive. Total is: ${box.length}');

    // box.toMap().forEach((key, value) {
    //   print('Key: $key, Value: $value');
    // });

    print(box.toMap());

    // Close the Hive box and cleanup
  }

  static Future<void> deleteChatFromHive(int key) async {
    final box = await Hive.openBox('chat_box');
    box.deleteAt(key);
    print('Item $key is Deleted');
  }

  static String getCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy  HH:mm:ss');
    print(formatter.format(now));
    return formatter.format(now);
  }
}

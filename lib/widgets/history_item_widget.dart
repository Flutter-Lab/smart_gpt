// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/chatscreen.dart';

import '../constants.dart';
import 'text_widget.dart';

class HistoryItemWidget extends StatelessWidget {
  const HistoryItemWidget({
    Key? key,
    required this.chatList,
    required this.index,
  }) : super(key: key);

  final chatList;
  final int index;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> convertedChatList = convertList(chatList);

    print(convertedChatList.length);

    print(chatList[index]);

    String msg = chatList[index][0]['conversation'][0]['msg'];
    String timeStamp = chatList[index][0]['timeStamp'];

    return Card(
      color: ColorPallate.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: TextWidget(
            label: index.toString(),
            color: Colors.grey,
          ),
          title: TextWidget(
            label: msg,
            color: Colors.white,
          ),
          subtitle: TextWidget(
            label: timeStamp,
            color: Colors.grey,
            fontSize: 16,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          convertedChatList,
                        )));
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> convertList(var chatList) {
    List<Map<String, dynamic>> oldConv = [];

    // chatList[index][0]['conversation'].map((item) {
    //   print(item.runtimeType);
    //   Map<String, dynamic> convertedMap = {};
    //   item.forEach((key, value) {
    //     convertedMap[key.toString()] = value;
    //   });
    //   oldConv.add(convertedMap);
    // });

    // chatgpt
    // chatList.forEach((item) {
    //   item[0]['conversation'].forEach((conversationItem) {
    //     print(conversationItem);
    //     Map<String, dynamic> convertedMap = {};
    //     conversationItem.forEach((key, value) {
    //       convertedMap[key.toString()] = value;
    //     });
    //     oldConv.add(convertedMap);
    //   });
    // });

    // chatList.forEach((item) {
    //   print(item.length);
    //   print(item[0]);
    // });

    return oldConv;
  }
}

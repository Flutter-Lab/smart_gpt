// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/chatscreen.dart';

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
    List<Map<String, dynamic>> oldConv = [];

    convertList(oldConv);

    return Card(
      color: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            print(oldConv.runtimeType);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          oldConv,
                        )));
          },
          title: Text(
            chatList[index][0]['conversation'][0]['msg'],
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          subtitle: Text(
            chatList[index][0]['timeStamp'],
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void convertList(List<Map<String, dynamic>> oldConv) {
    chatList[index][0]['conversation'].map((item) {
      print(item.runtimeType);
      Map<String, dynamic> convertedMap = {};
      item.forEach((key, value) {
        convertedMap[key.toString()] = value;
      });
      oldConv.add(convertedMap);
    });
  }
}

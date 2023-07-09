// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/chatscreen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final myBox = Hive.box('myBox');
    final chatList = myBox.values.toList();

    List<Map<String, dynamic>> oldConv = [];

    chatList.forEach((item) {
      item[0]['conversation'].forEach((conversationItem) {
        Map<String, dynamic> convertedMap = {};
        conversationItem.forEach((key, value) {
          convertedMap[key.toString()] = value;
        });
        oldConv.add(convertedMap);
      });
    });

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              oldConv,
                            ),
                          ),
                        );
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

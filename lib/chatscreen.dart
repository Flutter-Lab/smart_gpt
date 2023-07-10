// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:smart_gpt_ai/history_page.dart';
import 'package:smart_gpt_ai/old/services/api_service.dart';
import 'package:smart_gpt_ai/start_screen.dart';

final myBox = Hive.box('myBox');

class ChatScreen extends StatefulWidget {
  List<Map<String, dynamic>> conversation;
  int id;
  int indexNumber;
  String dateTime;

  ChatScreen(this.conversation, this.id, this.dateTime, this.indexNumber);

  @override
  State<ChatScreen> createState() => _ChatScreenState();

  List<Map<String, dynamic>> getConversation() {
    return conversation;
  }
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> oldConversation = [];
  List<Map<String, dynamic>> conv = [];
  List<Map<String, dynamic>> addedConversation = [];
  List<Map<String, dynamic>> modifiedList = [];
  int id = 0;
  String dateTime = '';
  int indexNumber = 0;
  int checkLength = 0;
  int count = 0;

  bool gettingReply = false;
  TextEditingController _controller = TextEditingController();

  late String question = '';
  late String replyByBot;

  void replyFunction() async {
    setState(() {
      gettingReply = true;
    });
    await Future.delayed(Duration(seconds: 1));
    String botReply = await ApiService.sendMessage(message: question);
    setState(() {
      gettingReply = false;
      conv.add({"msg": botReply, "index": 1});
      addedConversation.add({"msg": botReply, "index": 1});
    });
  }

  @override
  Widget build(BuildContext context) {
    conv = widget.conversation;
    id = widget.id;
    dateTime = widget.dateTime;
    indexNumber = widget.indexNumber;

    if (count < 1) {
      if (conv.length == 1) {
        replyFunction();
      }
      question = widget.conversation[0]["msg"];
      oldConversation = widget.conversation;
      print(widget.conversation);
      checkLength = widget.conversation.length;
      count++;
    }

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () async {
              DateTime now = DateTime.now();
              int milliseconds = now.millisecondsSinceEpoch;
              String uniqueId = '$milliseconds';
              String formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(now);
              if (checkLength == conv.length) {
                //if true means no changes happed.
              } else {
                if (id == 0) {
                  List<Map<String, dynamic>> conWithTime = [];
                  conWithTime.add({
                    "conversation": conv,
                    "ID": uniqueId,
                    "timeStamp": formattedDate
                  });
                  await myBox.add(conWithTime);
                } else {
                  modifiedList = [];
                  final hiveList = myBox.values.toList();
                  var targetID = oldConversation;

                  modifiedList.add({
                    "conversation": hiveList[indexNumber][0]["conversation"],
                    "ID": uniqueId,
                    "timeStamp": formattedDate
                  });
                  // print(modifiedList);
                  myBox.put(indexNumber, modifiedList);

                  addedConversation.forEach((element) async {
                    await hiveList[indexNumber][0]["conversation"].add(element);
                  });

                  // print(hiveList[indexNumber]);
                  // print(hiveList[indexNumber]);
                }
              }
              // final hiveList = myBox.values.toList();
              // print(hiveList);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                if (checkLength > 1) {
                  return StartScreen(pageIndex: 1);
                } else {
                  return StartScreen(pageIndex: 0);
                }
              }));
            },
          ),
          title: Text("chat screen")),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
                  itemCount: widget.conversation.length,
                  itemBuilder: (context, index) => Text(
                        widget.conversation[index]["msg"],
                        style: TextStyle(color: Colors.white),
                      ))),
          if (gettingReply) CircularProgressIndicator(),
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _controller,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    question = _controller.text;
                    _controller.clear();
                    setState(() {
                      conv.add({"msg": question, "index": 0});
                      addedConversation.add({"msg": question, "index": 0});
                    });
                    replyFunction();
                  },
                  child: Text('submit')),
            ],
          ),
        ],
      ),
    );
  }
}

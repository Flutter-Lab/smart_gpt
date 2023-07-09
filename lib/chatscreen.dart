// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

final myBox = Hive.box('myBox');

class ChatScreen extends StatefulWidget {
  List<Map<String, dynamic>> conversation;
  int id;
  String dateTime;

  ChatScreen(this.conversation, this.id, this.dateTime);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> conv = [];
  int id = 0;
  String dateTime = '';
  int checkLength = 0;
  int count = 0;

  late String question = 'This is another question';
  late String replyByBot;

  void waitFunction() async {
    await Future.delayed(Duration(seconds: 2));
    replyByBot = 'you are so telented';
    setState(() {
      conv.add({"msg": replyByBot, "index": 1});
    });
  }

  @override
  void initState() {
    waitFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    conv = widget.conversation;
    id = widget.id;
    dateTime = widget.dateTime;

    if (count < 1) {
      checkLength = widget.conversation.length;
      count++;
    }

    return WillPopScope(
      onWillPop: () async {
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
            // myBox.put(1688869759112, {});
            // final hiveList = myBox.values.toList();
            // myBox.clear();
            var data = myBox.get('1688869759112');
            print(data);
          }
        }
        final hiveList = myBox.values.toList();
        print(hiveList);

        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("chat screen")),
        body: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    itemCount: widget.conversation.length,
                    itemBuilder: (context, index) => Text(
                          widget.conversation[index]["msg"],
                          style: TextStyle(color: Colors.white),
                        ))),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    conv.add({"msg": question, "index": 0});
                  });
                  waitFunction();
                },
                child: Text('submit')),
          ],
        ),
      ),
    );
  }
}

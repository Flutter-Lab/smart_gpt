import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

final myBox = Hive.box('myBox');

List<Map<String, dynamic>> conv = [];

class ChatScreen extends StatefulWidget {
  List<Map<String, dynamic>> conversation;

  ChatScreen(this.conversation);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
    print(conv);
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(now);

        List<Map<String, dynamic>> conWithTime = [];
        conWithTime.add({"conversation": conv, "timeStamp": formattedDate});
        await myBox.add(conWithTime);
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
                    itemBuilder: (context, index) =>
                        Text(widget.conversation[index]["msg"]))),
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

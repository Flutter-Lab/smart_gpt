// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:smart_gpt_ai/old/services/api_service.dart';
import 'package:smart_gpt_ai/start_screen.dart';
import 'constants.dart';
import 'widgets/text_widget.dart';

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
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.navigate_before,
                color: Colors.white,
              ),
              onPressed: () async {
                DateTime now = DateTime.now();
                int milliseconds = now.millisecondsSinceEpoch;
                String uniqueId = '$milliseconds';
                String formattedDate =
                    DateFormat('yyyy/MM/dd HH:mm').format(now);
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
                    myBox.put(indexNumber, modifiedList);

                    addedConversation.forEach((element) async {
                      await hiveList[indexNumber][0]["conversation"]
                          .add(element);
                    });
                  }
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  if (checkLength > 1) {
                    return StartScreen(pageIndex: 1);
                  } else {
                    return StartScreen(pageIndex: 0);
                  }
                }));
              },
            ),
            Center(
              child: Text(
                "Chat screen",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        backgroundColor: ColorPallate.cardColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: widget.conversation.length,
                  itemBuilder: (context, index) {
                    String msg = widget.conversation[index]["msg"];
                    int chatIndex = widget.conversation[index]["index"];
                    return Container(
                      margin: EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        left: chatIndex == 0 ? 24 : 4,
                        right: chatIndex == 0 ? 4 : 24,
                      ),
                      decoration: BoxDecoration(
                          color: chatIndex == 0
                              ? Color.fromARGB(255, 28, 196, 103)
                              : cardColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft:
                                Radius.circular(chatIndex == 0 ? 12 : 0),
                            bottomRight:
                                Radius.circular(chatIndex == 0 ? 0 : 12),
                          )),
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                chatIndex == 0
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                  child: TextWidget(
                                                    label: msg,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : DefaultTextStyle(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        child: Text(msg)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (gettingReply) CircularProgressIndicator(),

              //Send Message Input Section
              Container(
                padding: EdgeInsets.all(8.0),
                color: ColorPallate.cardColor,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: ColorPallate.bgColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _controller,
                          onSubmitted: (value) async {},
                          decoration: InputDecoration.collapsed(
                              hintText: 'How can I help you?',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        question = _controller.text;
                        _controller.clear();
                        setState(() {
                          conv.add({"msg": question, "index": 0});
                          addedConversation.add({"msg": question, "index": 0});
                        });
                        replyFunction();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     Flexible(
              //       child: TextField(
              //         controller: _controller,
              //       ),
              //     ),
              //     ElevatedButton(
              //         onPressed: () {
              //           question = _controller.text;
              //           _controller.clear();
              //           setState(() {
              //             conv.add({"msg": question, "index": 0});
              //             addedConversation.add({"msg": question, "index": 0});
              //           });
              //           replyFunction();
              //         },
              //         child: Text('submit')),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

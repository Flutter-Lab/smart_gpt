// ignore_for_file: prefer_const_constructors

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:smart_gpt_ai/widgets/history_item_widget.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../constants/constants.dart';

import '../testings/hive-test/chat_model.dart';
import 'chat_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPallate.cardColor,
          title: Center(
            child: TextWidget(label: 'History', fontSize: 20),
          ),
          automaticallyImplyLeading: false,
          actions: [
            //If this is History Screen
            PopupMenuButton(
                color: ColorPallate.bgColor,
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        onTap: () async {
                          await clearChatBox();
                          setState(() {});
                        },
                        child: Text(
                          'Delete All History',
                          style: TextStyle(color: Colors.white),
                        )),
                  ];
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: FutureBuilder(
                    future: openChatBox(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        var chatList = snapshot.data!.values.toList();

                        chatList.sort((a, b) =>
                            b.lastUpdateTime.compareTo(a.lastUpdateTime));

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: chatList.length,
                            itemBuilder: (context, index) {
                              Chat chat = chatList[index];

                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(chat.lastUpdateTime));

                              String formattedDate =
                                  DateFormat('dd/MM/yyyy hh:mm a')
                                      .format(dateTime);

                              return HistoryItemWidget(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                  gobackPageIndex: 2,
                                                  chatObject: chat,
                                                )));
                                  },
                                  title: chat.chatMessageList[0].msg,
                                  timeStamp: formattedDate);
                            });
                      } else {
                        return Center(
                          child: TextWidget(
                            label: 'History is Empty',
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
  }

  Future<Box<Chat>> openChatBox() async {
    var chatBox = await Hive.openBox<Chat>('chatBox');
    return chatBox;
  }

  Future<void> clearChatBox() async {
    var chatBox = await Hive.openBox<Chat>('chatBox');
    chatBox.clear();
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/chat_screen.dart';
import 'package:smart_gpt_ai/widgets/history_item_widget.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import 'constants/constants.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var myBox = Hive.box('myBox');
  List<Map<String, dynamic>> oldConv = [];
  int count = 0;
  var hiveList = [];

  Future<void> sortFunction() async {
    if (count == 0) {
      count = 1;
      hiveList = myBox.values.toList();
      if (hiveList.length > 1) {
        hiveList.sort((b, a) => a[0]['ID'].compareTo(b[0]['ID']));
        await myBox.clear();
        for (var entry in hiveList) {
          myBox.add(entry);
        }
        var updatedHiveList = myBox.values.toList();
        hiveList = updatedHiveList;
        // print(hiveList);
        // print('first');
      }
    }
  }

  @override
  void initState() {
    sortFunction();

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
                          var myBox = Hive.box('myBox');
                          await myBox.clear();
                          hiveList = [];
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
              hiveList.isNotEmpty
                  ? Flexible(
                      child: ListView.builder(
                          itemCount: hiveList.length,
                          itemBuilder: (context, index) {
                            try {
                              if (index >= 0 && index < hiveList.length) {
                                String msg = hiveList[index][0]["conversation"]
                                    [0]["msg"];
                                String timeStamp =
                                    hiveList[index][0]["timeStamp"];
                                return HistoryItemWidget(
                                  title: msg,
                                  timeStamp: timeStamp,
                                  onPressed: () {
                                    oldConv = [];
                                    List<dynamic> ontimeList =
                                        hiveList[index][0]["conversation"];
                                    for (var element in ontimeList) {
                                      Map<String, dynamic> convertedMap =
                                          Map<String, dynamic>.from(
                                              element.cast<String, dynamic>());
                                      oldConv.add(convertedMap);
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                  conversation: oldConv,
                                                  id: 1,
                                                  gobackPageIndex: 2,
                                                  dateTime: '',
                                                )));
                                  },
                                );
                              } else {
                                return Container();
                              }
                            } catch (error) {
                              if (kDebugMode) {
                                print(error);
                              }
                            }
                            return null;
                          }),
                    )
                  : Expanded(
                      child: Center(
                        child: TextWidget(
                          label: 'History is Empty',
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}

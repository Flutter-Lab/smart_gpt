// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/chatscreen.dart';

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
        print(hiveList);
        print('first');
      }
    }
  }

  @override
  void initState() {
    sortFunction();
    ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        hiveList.length > 0
            ? Flexible(
                child: ListView.builder(
                    itemCount: hiveList.length,
                    itemBuilder: (context, index) {
                      try {
                        if (index >= 0 && index < hiveList.length) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  oldConv = [];
                                  List<dynamic> ontimeList =
                                      hiveList[index][0]["conversation"];
                                  ontimeList.forEach((element) {
                                    Map<String, dynamic> convertedMap =
                                        Map<String, dynamic>.from(
                                            element.cast<String, dynamic>());
                                    oldConv.add(convertedMap);
                                  });
                                  // print(ontimeList);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              oldConv, 1, '', index)));
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      hiveList[index][0]["conversation"][0]
                                          ["msg"],
                                      style: TextStyle(),
                                    ),
                                    Text(hiveList[index][0]["timeStamp"]),
                                  ],
                                )),
                          );
                        } else {
                          return Container();
                        }
                      } catch (error) {
                        // print(error);
                      }
                    }),
              )
            : Center(
                child: Text("No History Availeble"),
              ),
        ElevatedButton(
          onPressed: () async {
            await myBox.clear();
            hiveList = [];
            setState(() {});
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text('Delete All'), Icon(Icons.delete)],
          ),
        )
      ],
    ));
  }
}

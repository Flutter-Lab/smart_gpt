import 'package:flutter/foundation.dart';
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

  @override
  Widget build(BuildContext context) {
    var hiveList = myBox.values.toList();
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
                                    print(convertedMap);
                                  });

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatScreen(oldConv, 1, '')));
                                },
                                child: Text(
                                  hiveList[index][0]["conversation"][0]["msg"],
                                  style: TextStyle(),
                                )),
                          );
                        } else {
                          return Container();
                        }
                      } catch (error) {
                        print(error);
                      }
                    }),
              )
            : Center(
                child: Text("No History Availeble"),
              ),
        ElevatedButton(
          onPressed: () {
            myBox.clear();
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

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> numberList = [];

  final chatBox = Hive.box('chat_box');
  @override
  Widget build(BuildContext context) {
    _refreshItems();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: numberList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Center(
                    child: TextWidget(
                      label: numberList[index]['number'].toString(),
                      color: Colors.black,
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  int newItem = numberList.length + 1;

                  numberList.add({'number': newItem});

                  Map<String, dynamic> item = {'number': newItem};

                  await chatBox.add(item);

                  print('Total Data: ${chatBox.length}');

                  _refreshItems();
                },
                child: Text('Add Item'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    numberList.clear();
                    chatBox.clear();
                  });
                },
                child: Text('Clear List'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _refreshItems() {
    final data = chatBox.keys.map((key) {
      final item = chatBox.get(key);
      return {"key": key, "number": item["number"]};
    }).toList();

    setState(() {
      numberList = data.reversed.toList();
    });
  }
}

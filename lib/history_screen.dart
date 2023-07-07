// ignore_for_file: prefer_const_constructors
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'widgets/history_item_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final myBox = Hive.box('myBox');
    final chatList = myBox.values.toList();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) => HistoryItemWidget(
                chatList: chatList,
                index: index,
              ),
              // Text('Data'),
            ))
          ],
        ),
      ),
    );
  }
}

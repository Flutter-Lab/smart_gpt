// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../constants.dart';
import 'text_widget.dart';

class HistoryItemWidget extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String timeStamp;
  const HistoryItemWidget({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.timeStamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPallate.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: TextWidget(
            label: title,
            color: Colors.white,
          ),
          subtitle: TextWidget(
            label: timeStamp,
            color: Colors.grey,
            fontSize: 16,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
          onTap: () {
            onPressed();
          },
        ),
      ),
    );
  }
}

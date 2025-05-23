// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'text_widget.dart';

class HistoryItemWidget extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String timeStamp;
  String? Hkey;
  HistoryItemWidget(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.timeStamp,
      this.Hkey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPallate.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          title: TextWidget(
            label: title,
            fontSize: 15,
            color: Colors.white,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                label: timeStamp,
                color: Colors.grey,
                fontSize: 13,
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
          onTap: () {
            onPressed();
          },
        ),
      ),
    );
  }
}

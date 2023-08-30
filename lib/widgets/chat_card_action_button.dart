// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/constants/constants.dart';

import '../constants/screen_utils.dart';
import 'text_widget.dart';

class ChatCardActionButton extends StatelessWidget {
  String label;
  IconData icon;
  VoidCallback ontap;
  VoidCallback? onLongPress;

  ChatCardActionButton({
    required this.label,
    required this.icon,
    required this.ontap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onLongPress: onLongPress ??
            () {
              print('Long Press');
            },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: ColorPallate.bgColor,
              padding: EdgeInsets.symmetric(horizontal: 8)),
          onPressed: ontap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: ScreenUtil.screenWidth(context) * 0.032,
              ),
              SizedBox(width: 4),
              TextWidget(
                label: label,
                fontWeight: FontWeight.normal,
                fontSize: ScreenUtil.screenWidth(context) * 0.032,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

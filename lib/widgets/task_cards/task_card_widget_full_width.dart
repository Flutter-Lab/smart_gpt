import 'package:flutter/material.dart';

import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../../constants/constants.dart';

class TaskCardFullWidth extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback? onPressed;
  const TaskCardFullWidth({
    Key? key,
    required this.title,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 10),
        margin: const EdgeInsets.all(4),
        height: 70,

        constraints: const BoxConstraints(
          minHeight: 60.0, // Set the minimum height here
        ),
        // height: 100,
        decoration: BoxDecoration(
            color: ColorPallate.cardColor,
            borderRadius: BorderRadius.circular(16.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    label: title,
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  label: icon,
                  fontSize: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:smart_gpt_ai/constants/constants.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

class TaskCard extends StatelessWidget {
  String title;
  double? titleFontSize;
  String? subtitle;
  Color? titleColor;
  final String icon;
  bool? isFullWidth;
  VoidCallback? onPressed;
  TaskCard({
    required this.title,
    this.titleFontSize,
    this.subtitle,
    this.titleColor,
    required this.icon,
    this.isFullWidth,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 8, top: 8, bottom: 10),
        margin: const EdgeInsets.all(4),
        height: isFullWidth == true ? 70 : 100,
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
                mainAxisAlignment: isFullWidth != null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  TextWidget(
                    label: title,
                    color: titleColor ?? Colors.white,
                    fontSize: titleFontSize ?? 16,
                  ),
                  subtitle != null
                      ? TextWidget(
                          label: subtitle!,
                          color: Colors.grey,
                          fontSize: 14,
                        )
                      : Container(),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: isFullWidth == true
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
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

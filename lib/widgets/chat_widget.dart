// ignore_for_file: prefer_const_constructors

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/constants/constants.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

class ChatWidget extends StatelessWidget {
  final String msg;
  final int chatIndex;
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: chatIndex == 0 ? 24 : 4,
        right: chatIndex == 0 ? 4 : 24,
      ),
      decoration: BoxDecoration(
          color: chatIndex == 0 ? Color.fromARGB(255, 28, 196, 103) : cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(chatIndex == 0 ? 12 : 0),
            bottomRight: Radius.circular(chatIndex == 0 ? 0 : 12),
          )),
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image.asset(
          //   chatIndex == 0 ? AssetsManager.userImage : AssetsManager.botImage,
          //   height: 30,
          //   width: 30,
          // ),
          // SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                chatIndex == 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: TextWidget(
                                    label: msg,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          repeatForever: false,
                          animatedTexts: [
                            TyperAnimatedText(msg),
                          ],
                        )),
              ],
            ),
          ),
          // chatIndex == 0
          //     ? const SizedBox.shrink()
          //     : Row(
          //         children: [],
          //       )
        ],
      ),
    );
  }
}

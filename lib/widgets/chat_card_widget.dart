import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';

class ChatCardWidget extends StatelessWidget {
  const ChatCardWidget({
    super.key,
    required this.chatIndex,
    required this.msg,
  });

  final int chatIndex;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 8,
              left: chatIndex == 0 ? 24 : 4,
              right: chatIndex == 0 ? 4 : 24,
            ),
            decoration: BoxDecoration(
              color: chatIndex == 0
                  ? const Color.fromARGB(255, 28, 196, 103)
                  : cardColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(chatIndex == 0 ? 12 : 0),
                bottomRight: Radius.circular(chatIndex == 0 ? 0 : 12),
              ),
            ),
            // padding: EdgeInsets.only(
            //   top: chatIndex == 0 ? 8 : 8,
            //   left: 8,
            //   bottom: chatIndex == 0 ? 8 : 16,
            //   right: 8,
            // ),
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      chatIndex == 0
                          ? DefaultTextStyle(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                              child: Column(
                                children: [
                                  // CopyIconWidget(context: context, msg: msg),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(child: SelectableText(msg)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : DefaultTextStyle(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                              child: Column(
                                children: [
                                  // CopyIconWidget(context: context, msg: msg),
                                  SelectableText(msg),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InkWell CopyIconWidget({required BuildContext context, required String msg}) {
    return InkWell(
      onTap: () {
        print(msg);

        Clipboard.setData(ClipboardData(text: msg));
        // Show a snackbar or any other feedback to the user indicating successful copy.

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Copied to clipboard')));
      },
      child: Container(
        alignment: Alignment.topRight,
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.copy,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}

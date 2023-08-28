// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/services/translate.dart';

import '../constants/constants.dart';

class MessageCardWidget extends StatefulWidget {
  MessageCardWidget(
      {super.key,
      required this.chatIndex,
      required this.msg,
      this.stream,
      required this.convLength,
      required this.currentMsgIndex});

  final int chatIndex;
  final String msg;
  Stream<String>? stream;
  final int convLength;
  final int currentMsgIndex;

  @override
  State<MessageCardWidget> createState() => _MessageCardWidgetState();
}

class _MessageCardWidgetState extends State<MessageCardWidget> {
  late String msgTxt;
  String? transMsg;

  @override
  Widget build(BuildContext context) {
    msgTxt = widget.msg;
    return Row(
      mainAxisAlignment: widget.chatIndex == 1
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 8,
              left: widget.chatIndex == 0 ? 24 : 4,
              right: widget.chatIndex == 0 ? 4 : 24,
            ),
            decoration: BoxDecoration(
              color: widget.chatIndex == 0
                  ? const Color.fromARGB(255, 28, 196, 103)
                  : cardColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(widget.chatIndex == 0 ? 12 : 0),
                bottomRight: Radius.circular(widget.chatIndex == 0 ? 0 : 12),
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
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      widget.chatIndex == 0
                          ? DefaultTextStyle(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal),
                              child: Column(
                                children: [
                                  // CopyIconWidget(context: context, msg: msg),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                          child: SelectableText(widget.msg)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : DefaultTextStyle(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // CopyIconWidget(context: context, msg: msg),
                                  widget.stream != null
                                      ? StreamBuilder<String>(
                                          stream: widget.stream,
                                          builder: (context, snapshot) {
                                            // print('Stream OK');
                                            return SelectableText(
                                              snapshot.data != null
                                                  ? snapshot.data!
                                                  : 'Thinking...',
                                            );
                                          })
                                      : SelectableText(
                                          transMsg != null ? transMsg! : msgTxt,
                                        ),
                                ],
                              ),
                            ),
                      // if (widget.chatIndex == 1)
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       GestureDetector(
                      //         onTap: () async {
                      //           transMsg = await Translate.translate(msgTxt);
                      //           setState(() {});
                      //           // setState(() {
                      //           //   msgTxt = trnsMsg;
                      //           // });
                      //         },
                      //         child: Icon(
                      //           Icons.translate,
                      //           color: Colors.green,
                      //         ),
                      //       )
                      //     ],
                      //   ),
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

  // InkWell CopyIconWidget({required BuildContext context, required String msg}) {
  //   return InkWell(
  //     onTap: () {
  //       print(msg);

  //       Clipboard.setData(ClipboardData(text: msg));
  //       // Show a snackbar or any other feedback to the user indicating successful copy.

  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('Copied to clipboard')));
  //     },
  //     child: Container(
  //       alignment: Alignment.topRight,
  //       child: Icon(
  //         Icons.copy,
  //         color: Colors.white,
  //         size: 15,
  //       ),
  //     ),
  //   );
  // }
}

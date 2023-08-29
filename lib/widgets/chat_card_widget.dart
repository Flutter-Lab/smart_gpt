// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';
import 'package:smart_gpt_ai/widgets/translate_language_dialog.dart';

import '../constants/constants.dart';
import '../services/translate.dart';

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

  String? transLanguage;

  bool transLoading = false;

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
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: widget.chatIndex == 1 ? 8 : 16,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
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
                      if (widget.chatIndex == 1 && widget.stream == null)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 8),
                                  height: 28,
                                  child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        if (transLoading)
                                          Center(
                                            child: Container(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2),
                                            ),
                                          ),
                                        ChatCardHelper(
                                          icon: Icons.translate,
                                          label: 'Translate',
                                          onLongPress: () async {
                                            if (msgTxt.isNotEmpty) {
                                              await transProcess();
                                            }
                                          },
                                          ontap: onTapTranslate,
                                        ),
                                        ChatCardHelper(
                                            label: 'Copy',
                                            icon: Icons.copy,
                                            ontap: () {
                                              Clipboard.setData(ClipboardData(
                                                text: transMsg != null
                                                    ? transMsg!
                                                    : msgTxt,
                                              ));
                                              // Show a snackbar or any other feedback to the user indicating successful copy.
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Copied to clipboard')));
                                            })
                                      ]))
                            ]),
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

  void onTapTranslate() async {
    if (msgTxt.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      transLanguage = await prefs.getString('transLanguage') ?? null;
      print(transLanguage);

      if (transLanguage == null) {
        await transProcess();
      } else {
        setState(() {
          transLoading = true;
        });
        transMsg = await Translate.translate(
            text: msgTxt, languageCode: transLanguage!);

        setState(() {
          transLoading = false;
        });
      }
    }
  }

  Future<void> transProcess() async {
    setState(() {
      transLoading = true;
    });
    await TransLangDialog(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    transLanguage = await prefs.getString('transLanguage') ?? null;

    print('New TransLang : $transLanguage');

    if (transLanguage != null) {
      String transMsgT =
          await Translate.translate(text: msgTxt, languageCode: transLanguage!);

      setState(() {
        transMsg = transMsgT;
      });
      print(transMsgT);
    }
    setState(() {
      transLoading = false;
    });
  }

  Widget ChatCardHelper({
    required String label,
    required IconData icon,
    required VoidCallback ontap,
    VoidCallback? onLongPress,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorPallate.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: ontap,
            onLongPress: onLongPress ?? () {},
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 4),
                TextWidget(
                  label: label,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

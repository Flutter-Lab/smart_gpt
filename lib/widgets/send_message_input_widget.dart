// , unrelated_type_equality_checks, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_gpt_ai/functions/send_message.dart';

import '../constants/constants.dart';
import '../providers/chats_provider.dart';

class SendMessageInputWidget extends StatelessWidget {
  bool isChatScreen;
  TextEditingController textEditingController;

  SendMessageInputWidget({
    Key? key,
    required this.isChatScreen,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    // TextEditingController textEditingController =
    //     chatProvider.textEditingController;

    print('Loading status: ${chatProvider.isTypingStatus}');
    return Container(
      // margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(8.0),
      color: ColorPallate.cardColor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ColorPallate.bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: textEditingController,
                onSubmitted: (value) async {
                  await sendMessageFromChatScreen(
                      textEditingController, chatProvider, context);
                },
                decoration: InputDecoration.collapsed(
                    hintText: 'How can I help you?',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          IconButton(
            onPressed: !chatProvider.isTypingStatus
                ? () async {
                    await sendMessageFromChatScreen(
                        textEditingController, chatProvider, context);
                  }
                : () {
                    print('is Typing is True');
                    null;
                  },
            icon: Icon(
              !chatProvider.isTypingStatus ? Icons.send : Icons.stop,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessageFromChatScreen(
      TextEditingController textEditingController,
      ChatProvider chatProvider,
      BuildContext context) async {
    print('Send Button Clicked');
    String? msg = textEditingController.text;
    textEditingController.clear();
    // notifyListeners();
    await SendMessage.sendMessage(
        // chatProvider: chatProvider,
        context: context,
        currentMessage: msg,
        isChatScreen: isChatScreen);
  }
}

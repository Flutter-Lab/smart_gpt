import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chats_provider.dart';
import '../screens/chat_screen.dart';

class SendMessage with ChangeNotifier {
  static SendMessage? _instance;

  static SendMessage get instance {
    _instance ??= SendMessage();
    return _instance!;
  }

  static Future<void> sendMessage({
    // required ChatProvider chatProvider,
    required BuildContext context,
    bool isChatScreen = false,
    required String currentMessage,
  }) async {
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);
    if (isChatScreen == false) {
      chatProvider.chatList = [];
      instance.notifyListeners();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatScreen()));
    }
    if (currentMessage.isEmpty) {
      // ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
      //   content: TextWidget(
      //     label: 'Please type a mesage',
      //   ),
      //   backgroundColor: Colors.red,
      // ));

      print('Please type a mesage');
      return;
    }
    try {
      chatProvider.addUserMessage(msg: currentMessage);
      chatProvider.changeTypingStatus(true);
      instance.notifyListeners();
      print('Request Sent');
      await chatProvider.sendMessageAndGetAnswers(msg: currentMessage);
      // setState(() {});
    } catch (error) {
      print('Send message error: $error');
      // ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
      //   content: TextWidget(
      //     label: error.toString(),
      //   ),
      //   backgroundColor: Colors.red,
      // ));
    } finally {
      // scrollListToEnd();

      chatProvider.changeTypingStatus(false);
    }
  }
}

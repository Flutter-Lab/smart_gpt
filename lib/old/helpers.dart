  // Future<void> sendMessage({
  //   required ChatProvider chatProvider,
  //   required BuildContext context,
  //   bool isChatScreen = false,
  //   required currentMessage,
  // }) async {
  //   if (isChatScreen == false) {
  //     chatProvider.chatList = [];
  //     notifyListeners();
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => ChatScreen()));
  //   }
  //   if (currentMessage) {
  //     // ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
  //     //   content: TextWidget(
  //     //     label: 'Please type a mesage',
  //     //   ),
  //     //   backgroundColor: Colors.red,
  //     // ));

  //     print('Please type a mesage');
  //     return;
  //   }
  //   try {
  //     // var currentMessage = textEditingController.text;
  //     chatProvider.changeTypingStatus(true);
  //     setState(() {
  //       // widget.isTyping = true;
  //       // chatList.add(ChatModel(msg: currentMessage, chatIndex: 0));
  //       chatProvider.addUserMessage(msg: currentMessage);
  //       textEditingController.clear();
  //       focusNode.unfocus();
  //     });
  //     print('Request Sent');
  //     await chatProvider.sendMessageAndGetAnswers(msg: currentMessage);
  //     setState(() {});
  //   } catch (error) {
  //     print('Send message error: $error');
  //     // ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
  //     //   content: TextWidget(
  //     //     label: error.toString(),
  //     //   ),
  //     //   backgroundColor: Colors.red,
  //     // ));
  //   } finally {
  //     // scrollListToEnd();

  //     chatProvider.changeTypingStatus(false);
  //   }
  // }
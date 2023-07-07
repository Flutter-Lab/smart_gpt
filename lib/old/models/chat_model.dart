class ChatModel {
  final String msg;
  final int chatIndex;

  ChatModel({
    required this.msg,
    required this.chatIndex,
  });

  @override
  String toString() {
    return 'ChatModel(msg: $msg, chatIndex: $chatIndex)';
  }
}

class FullChat {
  String timeStamp;
  final List<ChatModel> chatModelList;

  FullChat({
    required this.timeStamp,
    required this.chatModelList,
  });
}

void main() {
  var chatModel1 = ChatModel(msg: 'how are you', chatIndex: 0);
  var chatModel2 = ChatModel(msg: 'i\'m fine, how about you? ', chatIndex: 1);
  var chatModel3 = ChatModel(msg: 'i\'m fine too.', chatIndex: 2);

  var fullChat1 = FullChat(
    timeStamp: "1111",
    chatModelList: [chatModel1, chatModel2, chatModel3],
  );

  print(fullChat1.chatModelList);
}

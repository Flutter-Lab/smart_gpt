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

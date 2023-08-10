import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Chat extends HiveObject {
  @HiveField(0)
  List<ChatMessage> chatMessageList;

  @HiveField(1)
  String lastUpdateTime;

  Chat({required this.chatMessageList, required this.lastUpdateTime});
}

@HiveType(typeId: 3)
class ChatMessage extends HiveObject {
  @HiveField(0)
  String msg;

  @HiveField(1)
  int senderIndex;

  ChatMessage({required this.msg, required this.senderIndex});
}

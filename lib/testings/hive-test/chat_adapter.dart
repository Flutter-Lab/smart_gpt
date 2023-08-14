import 'package:hive/hive.dart';

import 'chat_model.dart';

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 2; // Unique ID for the Chat type

  @override
  Chat read(BinaryReader reader) {
    final chatMessageListLength = reader.readByte();
    List<ChatMessage> chatMessageList = [];

    for (int i = 0; i < chatMessageListLength; i++) {
      chatMessageList.add(ChatMessageAdapter().read(reader));
    }

    return Chat(
      chatMessageList: chatMessageList,
      lastUpdateTime: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer.writeByte(obj.chatMessageList.length);

    for (ChatMessage chatMessage in obj.chatMessageList) {
      ChatMessageAdapter().write(writer, chatMessage);
    }

    writer.writeString(obj.lastUpdateTime);
  }
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 3; // Unique ID for the ChatMessage type

  @override
  ChatMessage read(BinaryReader reader) {
    return ChatMessage(
      msg: reader.readString(),
      senderIndex: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer.writeString(obj.msg);
    writer.writeInt(obj.senderIndex);
  }
}

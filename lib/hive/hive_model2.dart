import 'package:hive/hive.dart';
import '../models/chat_model.dart';

class FullChatAdapter extends TypeAdapter<FullChat> {
  @override
  int get typeId => 0; // Unique identifier for the adapter

  @override
  FullChat read(BinaryReader reader) {
    final timeStamp = reader.readString();
    final chatModelListLength = reader.readInt();
    final chatModelList = <ChatModel>[];

    for (var i = 0; i < chatModelListLength; i++) {
      chatModelList.add(ChatModel(
        msg: reader.readString(),
        chatIndex: reader.readInt(),
      ));
    }

    return FullChat(chatModelList: chatModelList, timeStamp: timeStamp);
  }

  @override
  void write(BinaryWriter writer, FullChat obj) {
    writer.writeString(obj.timeStamp);
    writer.writeInt(obj.chatModelList.length);

    for (var i = 0; i < obj.chatModelList.length; i++) {
      writer.writeString(obj.chatModelList[i].msg);
      writer.writeInt(obj.chatModelList[i].chatIndex);
    }
  }
}

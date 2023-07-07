List<Map<String, dynamic>> conversation = [];
List<Map<String, dynamic>> conWithTime = [];

String msg1 = 'hello i\'m under the water0';
String msg2 = 'hello i\'m under the water1';

void main() {
  conversation.add({"msg": msg1, "index": 1});
  conversation.add({"msg": msg2, "index": 2});
  conWithTime.add({"conversation": conversation, "timeStamp": '12/12/2023'});

  print(conversation[0]["msg"]);
  print(conWithTime);
}

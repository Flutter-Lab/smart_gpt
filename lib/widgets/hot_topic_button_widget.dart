import 'package:flutter/material.dart';

import '../chatscreen.dart';

class HotTopicButtonWidget extends StatelessWidget {
  const HotTopicButtonWidget({
    Key? key,
    required this.conversation,
    required this.hotTopics,
    required this.index,
  }) : super(key: key);

  final List<Map<String, dynamic>> conversation;
  final List<String> hotTopics;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        conversation.add({"msg": hotTopics[index], "index": 0});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(conversation, 0, '')));
      },
      child: Text(hotTopics[index]),
    );
  }
}

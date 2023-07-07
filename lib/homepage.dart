import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/chatscreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String hotTopic = 'tell me a joke';
    List<Map<String, dynamic>> conversation = [];

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                conversation.add({"msg": hotTopic, "index": 0});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(conversation)));
              },
              child: Text(hotTopic))
        ]),
      ),
    );
  }
}

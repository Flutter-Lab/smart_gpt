// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'chatscreen.dart';
import 'widgets/hot_topic_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> hotTopics = [
      'tell me a joke',
      'who is owner of twitter?',
      'what is color?',
      'what is light?',
    ];

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
            child: ListView.builder(
              itemCount: hotTopics.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    List<Map<String, dynamic>> conversation = [];
                    conversation.add({"msg": hotTopics[index], "index": 0});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(conversation)));
                  },
                  child: Text(hotTopics[index]),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

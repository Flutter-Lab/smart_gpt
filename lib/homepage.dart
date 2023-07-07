// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'widgets/hot_topic_button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> hotTopics = [
      'tell me a joke',
      'who is owner of twitter?',
      'what is color?',
      'what is light?',
    ];

    List<Map<String, dynamic>> conversation = [];

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
            child: ListView.builder(
              itemCount: hotTopics.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: HotTopicButtonWidget(
                    conversation: conversation,
                    hotTopics: hotTopics,
                    index: index),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

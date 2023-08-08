import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_gpt_ai/services/api_service.dart';
import 'package:dart_openai/dart_openai.dart';

class ChatStreamTest extends StatefulWidget {
  const ChatStreamTest({super.key});

  @override
  State<ChatStreamTest> createState() => _ChatStreamTestState();
}

class _ChatStreamTestState extends State<ChatStreamTest> {
  final StreamController<String> _streamController = StreamController<String>();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<String>(
                  stream: _streamController.stream,
                  initialData: 'Hi',
                  builder: (context, snapshot) {
                    return SingleChildScrollView(
                      child: Text(
                        snapshot.data!,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    getStreamResponse();
                  },
                  child: Text('Get Steam')),
            ],
          ),
        ),
      ),
    );
  }

  void getResponse() async {
    final apiKey =
        await ApiService.getApiKey(); // Replace with your OpenAI API key

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': "Write a 200 word story about a baby."}
        ],
        'temperature': 0,
        'stream': true,
      }),
    );

    if (response.statusCode == 200) {
      // Process the streaming response
      print('This is a Stream');
      final stream = Stream.value(response.body);
      await for (final chunk in stream) {
        print(chunk);
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void fetchData() async {
    print('Button Clicked');
    final apiKey = await ApiService.getApiKey();
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'user',
            'content':
                'Count to 100, with a comma between each number and no newlines. E.g., 1, 2, 3, ...'
          }
        ],
        'temperature': 0,
        'stream': true,
      }),
    );

// Inside the fetchData function
    if (response.statusCode == 200) {
      final responseStream = Stream.value(response.body);
      await for (final chunk in responseStream) {
        _streamController.add(chunk);
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> getStreamResponse() async {
    OpenAI.apiKey = await ApiService.getApiKey();
    String fullText = '';

    Stream<OpenAIStreamChatCompletionModel> chatStream =
        OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: "Why life is so tough?",
          role: OpenAIChatMessageRole.user,
        )
      ],
    );

    chatStream.listen((streamChatCompletion) {
      final content = streamChatCompletion.choices.first.delta.content;
      print(content);
      if (content != null) {
        fullText = fullText + content;
        _streamController.add(fullText);
      }
    });

    _streamController.done;
  }
}

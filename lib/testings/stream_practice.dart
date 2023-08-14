import 'dart:async';

import 'package:flutter/material.dart';

class StreamPracticeScreen extends StatefulWidget {
  const StreamPracticeScreen({super.key});

  @override
  State<StreamPracticeScreen> createState() => _StreamPracticeScreenState();
}

class _StreamPracticeScreenState extends State<StreamPracticeScreen> {
  StreamController<String> streamController = StreamController();
  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<String>(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  String data = '0';
                  if (snapshot.hasData) {
                    
                    data = snapshot.data.toString();
                  }
                  return Text(
                    data,
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  );
                }),
            ElevatedButton(
                onPressed: () {
                  NumberCreator();
                },
                child: Text('Start Stream')),
            ElevatedButton(
                onPressed: () {
                  streamController.close();
                },
                child: Text('Stop Stream')),
          ],
        ),
      ),
    );
  }

  NumberCreator() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      streamController.add(', $counter');
      print(counter);
      counter++;
    });
  }
}

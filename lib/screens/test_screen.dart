import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/services/api_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ApiService.getAndUpdateApiKey();
          },
          child: Text('Get API Kye'),
        ),
      ),
    );
  }
}

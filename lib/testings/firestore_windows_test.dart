import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/services/api_service.dart';

class WinFireScreen extends StatelessWidget {
  const WinFireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: ElevatedButton(
              onPressed: () async {
                await ApiService.getApiForAllFromDB();
              },
              child: Text('Get API'))),
    );
  }
}

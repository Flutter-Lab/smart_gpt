// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/start_screen.dart';
import 'package:smart_gpt_ai/utilities/shared_prefs.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final sharedPreferencesUtil = SharedPreferencesUtil();

    int totalSent = sharedPreferencesUtil.getInt('totalSent');
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(label: 'Get Pro Access', fontSize: 30),
                SizedBox(height: 16),
                Spacer(),
                ElevatedButton(onPressed: () {}, child: Text('Yearly Access')),
                SizedBox(height: 8),
                ElevatedButton(
                    onPressed: () {
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => StartScreen(pageIndex: 1)));
                    },
                    child: Text('Weekly Access')),
                SizedBox(height: 8),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        sharedPreferencesUtil.saveInt('totalSent', 0);

                        print('Total Chat Sent: $totalSent');

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StartScreen(pageIndex: 1)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Continue',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(252, 64, 212, 163),
                        foregroundColor: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

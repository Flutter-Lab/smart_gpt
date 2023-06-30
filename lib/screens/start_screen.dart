// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/constants/constants.dart';
import 'package:smart_gpt_ai/screens/history_screen.dart';
import 'package:smart_gpt_ai/screens/home_screen.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../services/assets_manager.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<String> appBarTitles = ['Smart GPT AI', 'Smart Task', 'History'];
  String appBarTitle = 'Smart GPT AI';
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final _allpages = [
      HomeScreen(),
      Center(child: TextWidget(label: 'Smart Task')),
      HistoryScreen(),
      // Center(child: TextWidget(label: 'History')),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            AssetsManager.networkLogo,
          ),
        ),
        title: Center(child: Text(appBarTitle)),
        actions: [
          IconButton(
              onPressed: () async {
                // await Services.showModelSheet(context: context);
              },
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: _allpages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorPallate.bgColor,
        selectedItemColor: ColorPallate.textColor,
        unselectedItemColor: ColorPallate.light2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_open_outlined), label: 'Smart Task'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'History'),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            appBarTitle = appBarTitles[index];
          });
        },
      ),
    );
  }
}

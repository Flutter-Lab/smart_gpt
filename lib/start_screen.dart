// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/history_page.dart';
import 'package:smart_gpt_ai/home_screen.dart';
import 'package:smart_gpt_ai/smart_task_screen.dart';

import 'constants/constants.dart';

class StartScreen extends StatefulWidget {
  final int pageIndex;
  const StartScreen({super.key, required this.pageIndex});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late int currentPageIndex;

  @override
  void initState() {
    currentPageIndex = widget.pageIndex;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [HomeScreen(), SmartTaskScreen(), HistoryPage()];
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorPallate.bgColor,
          selectedItemColor: ColorPallate.textColor,
          unselectedItemColor: ColorPallate.light2,
          type: BottomNavigationBarType.fixed,
          onTap: (value) => setState(() {
                currentPageIndex = value;
                // print(currentPageIndex);
              }),
          currentIndex: currentPageIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.tips_and_updates), label: 'Smart Task'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
          ]),
    );
  }
}

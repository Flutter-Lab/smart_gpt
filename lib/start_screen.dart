// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/history_screen.dart';
import 'package:smart_gpt_ai/homepage.dart';

import 'constants.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [HomeScreen(), HistoryScreen()];

    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorPallate.bgColor,
          selectedItemColor: ColorPallate.textColor,
          unselectedItemColor: ColorPallate.light2,
          type: BottomNavigationBarType.fixed,
          onTap: (value) => setState(() {
                currentPageIndex = value;
              }),
          currentIndex: currentPageIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
          ]),
    );
  }
}

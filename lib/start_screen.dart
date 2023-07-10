// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/history_page.dart';
import 'package:smart_gpt_ai/homepage.dart';

import 'constants.dart';

class StartScreen extends StatefulWidget {
  final int pageIndex;
  StartScreen({super.key, required this.pageIndex});

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
    List<Widget> pages = [HomeScreen(), HistoryPage()];
    // List<String> pageTitles = ['Smart GPT', 'History'];
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: ColorPallate.cardColor,
      //   title: Center(
      //       child: Text(
      //     pageTitles[currentPageIndex],
      //     style: TextStyle(color: Colors.white),
      //   )),
      //   automaticallyImplyLeading: false,
      //   actions: [
      //     //If this is History Screen

      //     if (currentPageIndex == 1)
      //       PopupMenuButton(
      //           color: Colors.white,
      //           itemBuilder: (context) {
      //             return [
      //               PopupMenuItem(
      //                   child: TextButton(
      //                 child: Text('Delete All'),
      //                 onPressed: () async {
      //                   var myBox = Hive.box('myBox');
      //                   await myBox.clear();
      //                   // hiveList = [];
      //                   setState(() {});
      //                 },
      //               ))
      //             ];
      //           })
      //   ],
      // ),
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorPallate.bgColor,
          selectedItemColor: ColorPallate.textColor,
          unselectedItemColor: ColorPallate.light2,
          type: BottomNavigationBarType.fixed,
          onTap: (value) => setState(() {
                currentPageIndex = value;
                print(currentPageIndex);
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

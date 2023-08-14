// import 'dart:async';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';

// class TestScreen extends StatefulWidget {
//   const TestScreen();

//   @override
//   State<TestScreen> createState() => _TestScreenState();
// }

// class _TestScreenState extends State<TestScreen> {
//   List textList = [];

//   String smallText = 'This is a Small Text';
//   String mediumText =
//       'Once you remove the advertising ID permission declaration from the manifest, rebuild and generate a new APK or app bundle for submission to the Play Console. This should resolve the warning about the advertising ID permission mismatch.';
//   String largeText =
//       "Thank you for downloading [App Name]! This is the first version of our app, packed with exciting features and functionalities.\n"
//       "Welcome to the official release of [App Name]. Enjoy a seamless user experience and explore all the features we have to offer.\n"
//       "Introducing [App Name] - your ultimate companion for [app's purpose]. Get started today and unlock a world of possibilities.\n"
//       "Version 1.0 brings a polished and optimized app experience. We've listened to your feedback and made several enhancements for a smooth user journey.";

//   bool isTyping = false;

//   final ScrollController _scrollController = ScrollController();

//   double? _previousHeight;
//   GlobalKey? _cardKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     // Start the timer to scroll to last item every 1 second
//     // _startScrollTimer();
//   }

//   Timer? _scrollTimer;

//   @override
//   void dispose() {
//     _scrollTimer?.cancel();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _startScrollTimer() {
//     _scrollTimer = Timer.periodic(Duration(seconds: 1), (_) {
//       _scrollToBottom();
//     });
//   }

//   void _onFlexibleHeightChanged() {
//     final RenderBox? renderBox =
//         _flexibleKey.currentContext?.findRenderObject() as RenderBox?;
//     if (renderBox != null) {
//       final height = renderBox.size.height;
//       if (_previousHeight != null && height != _previousHeight) {
//         print('Flexible height changed!');
//       }
//       _previousHeight = height;
//     }
//   }

//   final GlobalKey _flexibleKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Flexible(
//             child: Container(
//               child: ListView.builder(
//                   shrinkWrap: true,
//                   controller: _scrollController,
//                   itemCount: textList.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       child: Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           // child: Text('$index ${textList[index]}'),
//                           child: isTyping && index == textList.length - 1
//                               ? AnimatedTextKit(
//                                   animatedTexts: [
//                                     TypewriterAnimatedText(
//                                       '$index ${textList[index]}',
//                                     )
//                                   ],
//                                   isRepeatingAnimation: false,
//                                   // onNext: (p0, p1) {
//                                   //   _scrollToBottom();
//                                   // },
//                                 )
//                               : Text('$index ${textList[index]}'),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     textList.add(smallText);
//                     isTyping = true;
//                   });
//                 },
//                 child: Text('Small'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     textList.add(mediumText);
//                     isTyping = true;
//                   });
//                 },
//                 child: Text('Medium'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     textList.add(largeText);
//                     isTyping = true;
//                   });
//                 },
//                 child: Text('Big'),
//               ),
//               IconButton(
//                   onPressed: () {
//                     setState(() {
//                       textList = [];
//                     });
//                   },
//                   icon: Icon(
//                     Icons.delete,
//                     color: Colors.white,
//                   ))
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   void _scrollToBottom() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
// }

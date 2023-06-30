// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gpt_ai/constants/constants.dart';
import 'package:smart_gpt_ai/providers/chats_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:smart_gpt_ai/screens/start_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('chat_box');
  return runApp(
    DevicePreview(
      enabled: !kReleaseMode && !Platform.isAndroid,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: ColorPallate.bgColor,
          appBarTheme: AppBarTheme(
              color: ColorPallate.cardColor, foregroundColor: Colors.white),
          colorScheme: ColorScheme.fromSeed(seedColor: ColorPallate.bgColor),
          useMaterial3: true,
        ),
        home: StartPage(),
        // home: ChatScreen(),
      ),
    );
  }
}

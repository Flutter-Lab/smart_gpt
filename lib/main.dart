import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/hive-test/hive_test_screen.dart';
import 'package:smart_gpt_ai/screens/home_screen.dart';
import 'package:smart_gpt_ai/screens/start_screen.dart';

import 'package:smart_gpt_ai/glassfy_iap/purchase_api.dart';
import 'docs/firebase_options.dart';
import 'hive-test/chat_adapter.dart';
import 'hive-test/chat_model.dart';
import 'splash_screen.dart';
import 'utilities/shared_prefs.dart';
import 'constants/constants.dart';
import 'package:firedart/firedart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPreferencesUtil = SharedPreferencesUtil();
  await sharedPreferencesUtil.initialize();

  if (Platform.isAndroid) {
    await PurchaseApi.init();
  }
  Firestore.initialize(DefaultFirebaseOptions.windows.projectId);

  bool isUserPro = await PurchaseApi.isUserPremium() ||
      Platform.isIOS ||
      !kReleaseMode ||
      Platform.isWindows;

  sharedPreferencesUtil.saveBool('isPremium', isUserPro);

  await Hive.initFlutter();

  // Open the Hive box
  await Hive.openBox('myBox');

  Hive.registerAdapter<Chat>(ChatAdapter());
  Hive.registerAdapter<ChatMessage>(ChatMessageAdapter());

  return runApp(
    DevicePreview(
      enabled: !kReleaseMode && !Platform.isAndroid && !Platform.isIOS,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true, scaffoldBackgroundColor: ColorPallate.bgColor),
        // home: MyHomePage(
        home: SplashScreen()
        // home: StartScreen(
        //   pageIndex: 0,
        // )
        // home: HiveTestScreen(),

        // ),
        );
  }
}

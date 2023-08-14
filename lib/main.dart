import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/screens/start_screen.dart';
import 'package:smart_gpt_ai/glassfy_iap/purchase_api.dart';
import 'package:smart_gpt_ai/testings/stream_practice.dart';
import 'docs/firebase_options.dart';
import 'hive-test/chat_adapter.dart';
import 'hive-test/chat_model.dart';
import 'utilities/shared_prefs.dart';
import 'constants/constants.dart';
import 'package:firedart/firedart.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final sharedPreferencesUtil = SharedPreferencesUtil();
  await sharedPreferencesUtil.initialize();

  if (Platform.isAndroid) {
    await PurchaseApi.init();
  }
  Firestore.initialize(DefaultFirebaseOptions.windows.projectId);

  bool isUserPro = await PurchaseApi.isUserPremium();

  sharedPreferencesUtil.saveBool('isPremium', isUserPro);
  await Hive.initFlutter();
  Hive.registerAdapter<Chat>(ChatAdapter());
  Hive.registerAdapter<ChatMessage>(ChatMessageAdapter());

  return runApp(
    DevicePreview(
      enabled: !kReleaseMode && !Platform.isAndroid && !Platform.isIOS,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

// whenever your initialization is completed, remove the splash screen:

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true, scaffoldBackgroundColor: ColorPallate.bgColor),
      // home: MyHomePage(
      // home: SplashScreen()
      home: StartScreen(
        pageIndex: 0,
      ),
      // home: StreamPracticeScreen(),
    );
  }
}

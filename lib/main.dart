import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/screens/start_screen.dart';
import 'package:smart_gpt_ai/glassfy_iap/purchase_api.dart';
import 'docs/firebase_options.dart';
import 'testings/hive-test/chat_adapter.dart';
import 'testings/hive-test/chat_model.dart';
import 'utilities/shared_prefs.dart';
import 'constants/constants.dart';
import 'package:firedart/firedart.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await _initGoogleMobileAds();

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
        useMaterial3: true,
        scaffoldBackgroundColor: ColorPallate.bgColor,
        textTheme: TextTheme(
          bodyMedium:
              TextStyle(color: Colors.white), // Set default text color here
          // You can customize other text styles as well
        ),
      ),
      // home: MyHomePage(
      // home: SplashScreen()
      home: StartScreen(
        pageIndex: 0,
      ),
      // home: StreamPracticeScreen(),
    );
  }
}

Future<InitializationStatus> _initGoogleMobileAds() {
  // TODO: Initialize Google Mobile Ads SDK
  return MobileAds.instance.initialize();
}

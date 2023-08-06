import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/glassfy_iap/purchase_api.dart';
import 'package:smart_gpt_ai/splash_screen.dart';
import 'firebase_options.dart';
import 'utilities/shared_prefs.dart';
import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPreferencesUtil = SharedPreferencesUtil();
  await sharedPreferencesUtil.initialize();

  await PurchaseApi.init();

  bool isUserPro =
      await PurchaseApi.isUserPremium() || Platform.isIOS || !kReleaseMode;

  sharedPreferencesUtil.saveBool('isPremium', isUserPro);

  await Hive.initFlutter();

  // Open the Hive box
  await Hive.openBox('myBox');
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
        // home: const StartScreen(pageIndex: 0),
        // home: const TestScreen(),
        // home: MyHomePage(
        //   title: 'In App Home Page',
        home: SplashScreen()
        // ),
        );
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gpt_ai/glassfy_iap/purchase_api.dart';
import 'screens/start_screen.dart';
import 'utilities/shared_prefs.dart';
import 'constants/constants.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// // Gives the option to override in tests.
// class IAPConnection {
//   static InAppPurchase? _instance;
//   static set instance(InAppPurchase value) {
//     _instance = value;
//   }

//   static InAppPurchase get instance {
//     _instance ??= InAppPurchase.instance;
//     return _instance!;
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PurchaseApi.init();

  final sharedPreferencesUtil = SharedPreferencesUtil();
  await sharedPreferencesUtil.initialize();

  await Hive.initFlutter();

  // Open the Hive box
  await Hive.openBox('myBox');
  return runApp(
    DevicePreview(
      enabled: !kReleaseMode && !Platform.isAndroid,
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
      home: const StartScreen(pageIndex: 0),
      // home: MyHomePage(
      //   title: 'In App Home Page',
      // ),
    );
  }
}
